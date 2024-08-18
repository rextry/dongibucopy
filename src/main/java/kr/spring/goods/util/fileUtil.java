package kr.spring.goods.util;

import java.io.File;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

public class fileUtil {

    public static String createFile(HttpServletRequest request, MultipartFile file) throws IOException {
        String uploadDir = "/uploads"; // 파일 업로드 디렉토리
        String realPath = request.getServletContext().getRealPath(uploadDir); // 실제 경로 얻기

        File uploadPath = new File(realPath);
        if (!uploadPath.exists()) {
            uploadPath.mkdirs(); // 디렉토리가 없으면 생성
        }

        String originalFilename = file.getOriginalFilename();
        String uploadedFileName = uploadDir + "/" + originalFilename; // 경로 조합
        String filePath = realPath + "/" + originalFilename;

        File dest = new File(filePath);
        file.transferTo(dest); // 파일 저장

        return uploadedFileName; // 업로드된 파일의 경로 반환
    }
}