package com.jathinsahu.ecommerce.categoryservice.controllers;

import com.jathinsahu.ecommerce.categoryservice.dtos.ApiResponseDto;
import com.jathinsahu.ecommerce.categoryservice.exceptions.ServiceLogicException;
import com.jathinsahu.ecommerce.categoryservice.services.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/category")
public class CommonCategoryController {

    @Autowired
    private CategoryService categoryService;

    @GetMapping("/get/all")
    public ResponseEntity<ApiResponseDto<?>> getAllCategories() throws ServiceLogicException {
        return categoryService.getAllCategories();
    }

    @GetMapping("/get/byId")
    public ResponseEntity<ApiResponseDto<?>> getCategoryById(@RequestParam String id) throws ServiceLogicException {
        return categoryService.getCategoryById(id);
    }

}
