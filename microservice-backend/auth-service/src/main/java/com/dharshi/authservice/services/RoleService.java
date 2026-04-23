package com.jathinsahu.ecommerce.authservice.services;

import com.jathinsahu.ecommerce.authservice.enums.ERole;
import com.jathinsahu.ecommerce.authservice.modals.Role;
import org.springframework.stereotype.Service;

@Service
public interface RoleService {
    Role findByName(ERole eRole);
}