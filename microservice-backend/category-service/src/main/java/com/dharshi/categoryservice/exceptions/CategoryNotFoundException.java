package com.jathinsahu.ecommerce.categoryservice.exceptions;

public class CategoryNotFoundException extends RuntimeException{

    public CategoryNotFoundException(String message){
        super(message);
    }

}
