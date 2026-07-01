package uef.edu.vn.service;



import jakarta.servlet.ServletContext;

import java.io.IOException;

import java.io.InputStream;

import java.nio.file.Files;

import java.nio.file.Path;

import java.nio.file.StandardCopyOption;

import java.util.ArrayList;

import java.util.LinkedHashSet;

import java.util.List;

import java.util.Set;

import uef.edu.vn.exception.ValidationException;
import org.springframework.stereotype.Service;

import org.springframework.web.multipart.MultipartFile;



@Service

public class ProductImageService {



    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "gif", "webp");

    private static final String WEBAPP_PRODUCTS_DIR = "src/main/webapp/resources/images/products";

    private static final String TARGET_PRODUCTS_DIR = "target/auction-system-local/resources/images/products";



    public String saveImage(MultipartFile file, ServletContext servletContext) throws IOException {

        if (file == null || file.isEmpty()) {

            return null;

        }



        String originalName = file.getOriginalFilename();

        if (originalName == null || originalName.isBlank()) {

            throw new ValidationException("Tên file không hợp lệ");

        }



        String extension = getExtension(originalName);

        if (!ALLOWED_EXTENSIONS.contains(extension.toLowerCase())) {

            throw new ValidationException("Chỉ chấp nhận ảnh JPG, PNG, GIF, WEBP");

        }



        String safeName = originalName.replaceAll("[^a-zA-Z0-9._-]", "_");

        String storedName = System.currentTimeMillis() + "_" + safeName;



        List<Path> uploadDirs = resolveUploadDirs(servletContext);

        if (uploadDirs.isEmpty()) {

            throw new ValidationException("Không tìm thấy thư mục lưu ảnh");

        }



        Path primaryDir = uploadDirs.get(0);

        Files.createDirectories(primaryDir);

        Path savedFile = primaryDir.resolve(storedName);



        try (InputStream input = file.getInputStream()) {

            Files.copy(input, savedFile, StandardCopyOption.REPLACE_EXISTING);

        }



        for (int i = 1; i < uploadDirs.size(); i++) {

            Path dir = uploadDirs.get(i);

            Files.createDirectories(dir);

            Files.copy(savedFile, dir.resolve(storedName), StandardCopyOption.REPLACE_EXISTING);

        }



        return storedName;

    }



    private List<Path> resolveUploadDirs(ServletContext servletContext) {

        Set<String> seen = new LinkedHashSet<>();

        List<Path> dirs = new ArrayList<>();

        Path projectRoot = locateProjectRoot(servletContext);



        if (servletContext != null) {

            String realPath = servletContext.getRealPath("/resources/images/products/");

            if (realPath != null) {

                addDir(dirs, seen, Path.of(realPath));

            }

        }



        if (projectRoot != null) {

            addDir(dirs, seen, projectRoot.resolve(WEBAPP_PRODUCTS_DIR));

            addDir(dirs, seen, projectRoot.resolve(TARGET_PRODUCTS_DIR));

        }



        return dirs;

    }



    private Path locateProjectRoot(ServletContext servletContext) {

        Path fromWorkingDir = walkUpForPom(Path.of(System.getProperty("user.dir")).toAbsolutePath().normalize());

        if (fromWorkingDir != null) {

            return fromWorkingDir;

        }



        if (servletContext != null) {

            String basePath = servletContext.getRealPath("/");

            if (basePath != null) {

                return walkUpForPom(Path.of(basePath).toAbsolutePath().normalize());

            }

        }



        return null;

    }



    private Path walkUpForPom(Path start) {

        Path current = start;

        for (int depth = 0; depth < 12 && current != null; depth++) {

            if (Files.isRegularFile(current.resolve("pom.xml"))) {

                return current;

            }

            current = current.getParent();

        }

        return null;

    }



    private void addDir(List<Path> dirs, Set<String> seen, Path dir) {

        String key = dir.toAbsolutePath().normalize().toString();

        if (seen.add(key)) {

            dirs.add(dir.toAbsolutePath().normalize());

        }

    }



    private String getExtension(String filename) {

        int dot = filename.lastIndexOf('.');

        if (dot < 0 || dot == filename.length() - 1) {

            return "";

        }

        return filename.substring(dot + 1);

    }

}


