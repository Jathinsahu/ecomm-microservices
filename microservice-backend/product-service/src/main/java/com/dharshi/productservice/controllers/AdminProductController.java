package com.jathinsahu.ecommerce.productservice.controllers;

import com.jathinsahu.ecommerce.productservice.dtos.ApiResponseDto;
import com.jathinsahu.ecommerce.productservice.dtos.ProductRequestDto;
import com.jathinsahu.ecommerce.productservice.exceptions.ResourceNotFoundException;
import com.jathinsahu.ecommerce.productservice.exceptions.ServiceLogicException;
import com.jathinsahu.ecommerce.productservice.services.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin/product")
public class AdminProductController {

    @Autowired
    private ProductService productService;

    @PostMapping("/add")
    public ResponseEntity<ApiResponseDto<?>> addProduct(@RequestBody ProductRequestDto requestDto) throws ServiceLogicException, ResourceNotFoundException {
        return productService.addProduct(requestDto);
    }

    @PutMapping("/edit")
    public ResponseEntity<ApiResponseDto<?>> editProduct(@RequestParam String productId, @RequestBody ProductRequestDto requestDto) throws ServiceLogicException, ResourceNotFoundException {
        return productService.editProduct(productId, requestDto);
    }

}
