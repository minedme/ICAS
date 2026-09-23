package com.example.demo.util;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

public class QRCodeUtil {

    // 生成二维码的默认宽度
    public static final int DEFAULT_WIDTH = 300;
    // 生成二维码的默认高度
    public static final int DEFAULT_HEIGHT = 300;
    // 二维码的默认格式
    public static final String DEFAULT_FORMAT = "PNG";

    /**
     * 生成二维码图片流
     * @param content 二维码内容
     * @return 二维码图片的字节数组
     * @throws WriterException 二维码生成异常
     * @throws IOException 图片流写入异常
     */
    public static byte[] generateQRCode(String content) throws WriterException, IOException {
        return generateQRCode(content, DEFAULT_WIDTH, DEFAULT_HEIGHT, DEFAULT_FORMAT);
    }

    /**
     * 生成二维码图片流
     * @param content 二维码内容
     * @param width 二维码宽度
     * @param height 二维码高度
     * @param format 二维码图片格式
     * @return 二维码图片的字节数组
     * @throws WriterException 二维码生成异常
     * @throws IOException 图片流写入异常
     */
    public static byte[] generateQRCode(String content, int width, int height, String format) throws WriterException, IOException {
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        Map<EncodeHintType, Object> hints = new HashMap<>();
        hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
        
        BitMatrix bitMatrix = qrCodeWriter.encode(content, BarcodeFormat.QR_CODE, width, height, hints);
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        MatrixToImageWriter.writeToStream(bitMatrix, format, outputStream);
        
        return outputStream.toByteArray();
    }

    /**
     * 将二维码图片写入到指定路径
     * @param content 二维码内容
     * @param path 文件路径
     * @param width 二维码宽度
     * @param height 二维码高度
     * @param format 二维码图片格式
     * @throws WriterException 二维码生成异常
     * @throws IOException 图片写入异常
     */
    public static void writeQRCodeToFile(String content, Path path, int width, int height, String format) throws WriterException, IOException {
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        Map<EncodeHintType, Object> hints = new HashMap<>();
        hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
        
        BitMatrix bitMatrix = qrCodeWriter.encode(content, BarcodeFormat.QR_CODE, width, height, hints);
        MatrixToImageWriter.writeToPath(bitMatrix, format, path);
    }
}
