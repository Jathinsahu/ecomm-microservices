package com.jathinsahu.ecommerce.authservice.services;

import com.jathinsahu.ecommerce.authservice.enums.ERole;
import com.jathinsahu.ecommerce.authservice.modals.Role;
import com.jathinsahu.ecommerce.authservice.repositories.RoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class RoleServiceImpl implements RoleService {

    @Autowired
    private RoleRepository roleRepository;

    @Override
    public Role findByName(ERole eRole) {
        return roleRepository.findByName(eRole)
                .orElseThrow(() -> new RuntimeException("Role is not found."));
    }
}
