package com.jathinsahu.ecommerce.authservice.factories;

import com.jathinsahu.ecommerce.authservice.enums.ERole;
import com.jathinsahu.ecommerce.authservice.exceptions.RoleNotFoundException;
import com.jathinsahu.ecommerce.authservice.modals.Role;
import com.jathinsahu.ecommerce.authservice.services.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class RoleFactory {
    @Autowired
    RoleService roleService;

    public Role getInstance(String role) throws RoleNotFoundException {
        if (role.equals("admin")) {
            return roleService.findByName(ERole.ROLE_ADMIN);
        }
        else if (role.equals("user")){
            return roleService.findByName(ERole.ROLE_USER);
        }
        throw new RoleNotFoundException("Invalid role name: " + role);
    }

}
