package com.jathinsahu.ecommerce.orderservice.services;

import com.jathinsahu.ecommerce.orderservice.dtos.ApiResponseDto;
import com.jathinsahu.ecommerce.orderservice.dtos.OrderRequestDto;
import com.jathinsahu.ecommerce.orderservice.exceptions.ResourceNotFoundException;
import com.jathinsahu.ecommerce.orderservice.exceptions.ServiceLogicException;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
public interface OrderService {
    ResponseEntity<ApiResponseDto<?>> createOrder(String token, OrderRequestDto request) throws ResourceNotFoundException, ServiceLogicException;

    ResponseEntity<ApiResponseDto<?>> getOrdersByUser(String userId) throws ResourceNotFoundException, ServiceLogicException;

    ResponseEntity<ApiResponseDto<?>> cancelOrder(String orderId) throws ServiceLogicException, ResourceNotFoundException;

    ResponseEntity<ApiResponseDto<?>> getAllOrders() throws ServiceLogicException;
}
