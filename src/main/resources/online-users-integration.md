# 实时在线人数功能集成文档

## 1. 功能概述

本模块提供实时在线用户数量统计功能，通过 SSE（Server-Sent Events）技术实现服务器到客户端的实时数据推送，确保在线人数变化时能够立即更新显示。

## 2. 核心组件

### 2.1 会话监听器

**UserSessionListener.java**
- 实现 HttpSessionListener 接口，监听用户会话的创建和销毁
- 实现 ApplicationListener 接口，确保在 Spring 容器完全初始化后获取服务
- 在会话创建时调用 `OnlineUserService.increment()`
- 在会话销毁时调用 `OnlineUserService.decrement()`

### 2.2 在线用户服务

**OnlineUserService.java**
- 定义在线用户数量管理的核心方法
- 提供监听器注册机制，支持实时通知数量变化

**OnlineUserServiceImpl.java**
- 使用 AtomicInteger 实现线程安全的在线用户数量管理
- 使用 CopyOnWriteArraySet 存储监听器，确保并发安全
- 提供增量、减量、获取当前数量等核心功能
- 实现监听器通知机制，确保数量变化时实时通知所有客户端

### 2.3 控制器

**OnlineUserController.java**
- 提供 `/api/online-users` SSE 接口，用于实时推送在线人数
- 提供 `/api/online-users/count` 接口，用于获取当前在线人数（支持轮询）
- 实现 SSE 连接管理和错误处理

### 2.4 前端集成

在管理员仪表板页面（`admin/dashboard.jsp`）中：
- 添加在线人数显示卡片
- 实现 SSE 客户端代码，连接到服务器获取实时更新
- 提供浏览器不支持 SSE 时的轮询降级方案
- 添加错误处理和重连机制

## 3. 技术特点

### 3.1 性能优化
- 使用 SSE 技术，避免频繁的客户端请求
- 线程安全的并发控制，使用 AtomicInteger 和 CopyOnWriteArraySet
- 高效的监听器通知机制，确保只在数量变化时发送更新

### 3.2 可靠性保障
- 完善的错误处理机制，确保单个客户端错误不会影响其他客户端
- 浏览器兼容性考虑，提供 SSE 和轮询两种方案
- 连接异常时的自动重连机制

### 3.3 实时性
- 服务器推送机制，确保数量变化立即通知客户端
- 低延迟的事件处理，减少更新延迟

## 4. 集成说明

### 4.1 后端集成

1. 确保所有核心组件已正确实现（监听器、服务、控制器）
2. 检查 Spring 配置，确保组件被正确扫描和注入
3. 确认项目支持 SSE 技术（Spring Boot 2.x 及以上版本默认支持）

### 4.2 前端集成

在需要显示在线人数的页面中添加以下代码：

```html
<!-- 在线人数显示卡片 -->
<div class="card">
    <h3>当前在线</h3>
    <div class="card-value" id="onlineUsers">0</div>
</div>

<!-- SSE 客户端代码 -->
<script>
    function initSSE() {
        if (typeof(EventSource) !== "undefined") {
            const eventSource = new EventSource('/smart-classroom/api/online-users');
            
            eventSource.onmessage = function(event) {
                try {
                    const data = JSON.parse(event.data);
                    document.getElementById('onlineUsers').textContent = data.count;
                } catch (error) {
                    console.error('解析SSE数据失败:', error);
                }
            };
            
            eventSource.onerror = function(error) {
                console.error('SSE连接错误:', error);
                // 尝试重新连接
                setTimeout(initSSE, 5000);
            };
            
            // 页面关闭时关闭连接
            window.addEventListener('beforeunload', function() {
                eventSource.close();
            });
        } else {
            // 浏览器不支持SSE，使用定时轮询
            console.log('浏览器不支持SSE，使用定时轮询');
            setInterval(updateOnlineUsers, 10000);
        }
    }
    
    // 轮询方式获取在线人数
    function updateOnlineUsers() {
        fetch('/smart-classroom/api/online-users/count')
            .then(response => response.json())
            .then(count => {
                document.getElementById('onlineUsers').textContent = count;
            })
            .catch(error => {
                console.error('获取在线人数失败:', error);
            });
    }
    
    // 初始化
    window.onload = function() {
        initSSE();
    };
</script>
```

## 5. 接口文档

### 5.1 SSE 实时推送接口

**URL**: `/api/online-users`
**Method**: GET
**Content-Type**: text/event-stream
**Response**: 实时推送在线人数变化

**示例响应**: 
```
data: {"count":123}
```

### 5.2 获取当前在线人数接口

**URL**: `/api/online-users/count`
**Method**: GET
**Content-Type**: application/json
**Response**: 当前在线用户数量

**示例响应**: 
```json
123
```

## 6. 错误处理

### 6.1 服务器端错误处理
- SSE 连接异常时自动移除监听器
- 服务层异常时确保不影响其他客户端
- 使用 try-catch 包裹关键操作，确保系统稳定性

### 6.2 客户端错误处理
- SSE 连接失败时自动重连
- 解析数据失败时记录日志并继续运行
- 浏览器不支持 SSE 时自动切换到轮询方案
- 网络请求失败时记录日志并继续尝试

## 7. 性能与安全

### 7.1 性能优化
- 避免不必要的数据库查询，使用内存缓存计数
- 减少网络传输数据量，只传输必要的信息
- 使用高效的并发控制机制，减少锁竞争

### 7.2 安全考虑
- 限制 SSE 连接的生命周期，避免资源泄漏
- 实现连接数控制，防止恶意客户端占用过多资源
- 对输入参数进行验证，确保系统安全

## 8. 测试与验证

### 8.1 功能测试
1. 启动应用，访问管理员仪表板
2. 观察在线人数显示是否正确
3. 打开多个浏览器窗口，测试在线人数是否实时更新
4. 关闭浏览器窗口，测试在线人数是否正确减少

### 8.2 性能测试
1. 模拟大量并发用户，测试系统性能
2. 检查内存和 CPU 使用率
3. 验证在线人数统计的准确性

### 8.3 兼容性测试
1. 在不同浏览器中测试功能
2. 验证 SSE 和轮询两种方案的正常工作

## 9. 扩展建议

1. **用户类型统计**：扩展功能，分别统计不同类型用户（管理员、教师、学生）的在线数量
2. **历史数据统计**：添加在线人数历史数据记录，支持查看在线人数趋势
3. **地理分布**：结合用户 IP 信息，统计在线用户的地理分布
4. **自定义通知**：支持根据在线人数阈值发送通知

## 10. 技术支持

如果在集成或使用过程中遇到问题，请检查以下几点：
1. 确保所有核心组件已正确实现和配置
2. 检查 SSE 连接是否正常建立
3. 查看服务器日志，定位错误原因
4. 验证前端 JavaScript 代码是否有语法错误

如需进一步支持，请联系开发团队。