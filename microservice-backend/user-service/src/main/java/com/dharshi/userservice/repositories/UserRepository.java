package com.jathinsahu.ecommerce.userservice.repositories;

import com.jathinsahu.ecommerce.userservice.modals.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface UserRepository extends MongoRepository<User, String> {

}
