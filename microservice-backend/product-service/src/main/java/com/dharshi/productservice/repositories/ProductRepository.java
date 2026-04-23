package com.jathinsahu.ecommerce.productservice.repositories;


import com.jathinsahu.ecommerce.productservice.models.Product;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface ProductRepository extends MongoRepository<Product,String> {

    List<Product> findByCategoryId(String categoryId);
    List<Product> findByProductNameContainingIgnoreCaseOrDescriptionContainingIgnoreCaseOrCategoryNameContainingIgnoreCase(String ProductName, String description, String categoryName);

}
