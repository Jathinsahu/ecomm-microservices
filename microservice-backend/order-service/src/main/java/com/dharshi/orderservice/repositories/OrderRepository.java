package com.jathinsahu.ecommerce.orderservice.repositories;

import com.jathinsahu.ecommerce.orderservice.modals.Order;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Set;

public interface OrderRepository extends MongoRepository<Order,String> {

    Set<Order> findByUserIdOrderByIdDesc(String userId);


}
