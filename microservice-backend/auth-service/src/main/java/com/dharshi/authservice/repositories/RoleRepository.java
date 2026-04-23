package com.jathinsahu.ecommerce.authservice.repositories;

import com.jathinsahu.ecommerce.authservice.enums.ERole;
import com.jathinsahu.ecommerce.authservice.modals.Role;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RoleRepository extends MongoRepository<Role, String> {
    Optional<Role> findByName(ERole name);
    boolean existsByName(ERole name);
}