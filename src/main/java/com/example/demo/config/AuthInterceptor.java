package com.example.demo.config;

import com.example.demo.model.User;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * 登录鉴权拦截器：校验登录状态与角色权限。
 * Web 页面未登录 302 跳转登录页；REST 接口（/mobile、/api）返回 401/403 JSON。
 */
public class AuthInterceptor implements HandlerInterceptor {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        Object userObj = session != null ? session.getAttribute("user") : null;

        String uri = request.getRequestURI();
        boolean isApi = uri.startsWith("/mobile") || uri.startsWith("/api");

        // 未登录
        if (!(userObj instanceof User)) {
            if (isApi) {
                writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, "未登录或会话已过期，请重新登录");
            } else {
                response.sendRedirect("/user/login");
            }
            return false;
        }

        // 角色校验
        User user = (User) userObj;
        String requiredRole = resolveRequiredRole(uri);
        if (requiredRole != null && !roleMatches(requiredRole, user.getRole())) {
            if (isApi) {
                writeJson(response, HttpServletResponse.SC_FORBIDDEN, "无权访问该资源");
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
            }
            return false;
        }
        return true;
    }

    /** 根据请求路径推断所需角色，null 表示任意登录用户 */
    private String resolveRequiredRole(String uri) {
        if (uri.startsWith("/admin") || uri.startsWith("/user")
                || uri.startsWith("/analysis") || uri.startsWith("/api")) {
            return "admin";
        }
        if (uri.startsWith("/teacher")) {
            return "teacher";
        }
        if (uri.startsWith("/student")) {
            return "student";
        }
        return null; // /mobile、/class/join 等任意登录用户，接口内部再做角色判断
    }

    /** 兼容 Web 端英文角色与移动端中文角色 */
    private boolean roleMatches(String expected, String actual) {
        if (actual == null) {
            return false;
        }
        switch (expected) {
            case "admin":
                return "admin".equals(actual) || "管理员".equals(actual);
            case "teacher":
                return "teacher".equals(actual) || "教师".equals(actual);
            case "student":
                return "student".equals(actual) || "学生".equals(actual);
            default:
                return expected.equals(actual);
        }
    }

    private void writeJson(HttpServletResponse response, int code, String message) throws Exception {
        response.setStatus(code);
        response.setContentType("application/json;charset=UTF-8");
        Map<String, Object> body = new HashMap<>();
        body.put("code", code);
        body.put("message", message);
        response.getWriter().write(OBJECT_MAPPER.writeValueAsString(body));
    }
}
