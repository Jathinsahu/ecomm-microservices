import { useState, useEffect } from "react"
import API_BASE_URL from "./apiConfig";
import axios from 'axios';

// Add axios interceptor for MAXIMUM debugging
axios.interceptors.request.use(request => {
    console.log('========== AXIOS REQUEST ==========');
    console.log('Full URL:', request.baseURL + request.url);
    console.log('Method:', request.method);
    console.log('Headers:', JSON.stringify(request.headers, null, 2));
    console.log('Data:', request.data);
    console.log('===================================');
    return request;
});

axios.interceptors.response.use(
    response => {
        console.log('========== AXIOS SUCCESS ==========');
        console.log('URL:', response.config.url);
        console.log('Status:', response.status);
        console.log('Data:', JSON.stringify(response.data, null, 2));
        console.log('===================================');
        return response;
    },
    error => {
        console.log('========== AXIOS ERROR ==========');
        console.log('URL:', error.config?.url);
        console.log('Full URL:', error.config?.baseURL + error.config?.url);
        console.log('Method:', error.config?.method);
        console.log('Status:', error.response?.status);
        console.log('Status Text:', error.response?.statusText);
        console.log('Error Data:', JSON.stringify(error.response?.data, null, 2));
        console.log('Error Headers:', JSON.stringify(error.response?.headers, null, 2));
        console.log('===================================');
        return Promise.reject(error);
    }
);

function CartService() {
    const [cart, setCart] = useState({})
    const [cartError, setError] = useState(false);
    const [isProcessingCart, setProcessing] = useState(false);
    const [userToken, setUserToken] = useState(localStorage.getItem("user"));

    const user = userToken ? JSON.parse(userToken) : null;

    const authHeader = () => {
        if (!user?.token) return {};
        const tokenType = user?.type?.trim() || 'Bearer';
        return { Authorization: `${tokenType} ${user?.token}` };
    }

    const addItemToCart = async (productId, quantity) => {
        setProcessing(true)
        await axios.post(
            `${API_BASE_URL}/api/cart-service/cart/add`,
            { productId, quantity },
            { headers: authHeader() }
        )
            .then((response) => {
                setError(false)
            })
            .catch((error) => {
                setError(true)
            })
        setProcessing(false)
        getCartInformation()
    }

    const updateItemQuantity = async (productId, quantity) => {
        setProcessing(true)
        await axios.post(
            `${API_BASE_URL}/api/cart-service/cart/add`,
            { productId, quantity },
            { headers: authHeader() }
        )
            .then((response) => {
                setError(false)
            })
            .catch((error) => {
                setError(true)
            })
        setProcessing(false)
        getCartInformation()
    }

    const removeItemFromCart = async (productId) => {
        setProcessing(true)
        await axios.delete(`${API_BASE_URL}/api/cart-service/cart/remove`, {
            headers: authHeader(),
            params: {
                productId: productId
            }
        })
            .then((response) => {
                setError(false)
            })
            .catch((error) => {
                setError(true)
            })
        getCartInformation()
    }

    const getCartInformation = async () => {
        console.log('\n========== GET CART INFORMATION ==========');
        console.log('Step 1 - Raw userToken from state:', userToken);
        console.log('Step 2 - Parsed user:', user);
        console.log('Step 3 - User token exists:', !!user?.token);
        console.log('Step 4 - User token value:', user?.token);
        console.log('Step 5 - API_BASE_URL:', API_BASE_URL);
        
        if (!user?.token) {
            console.log('>>> NO TOKEN - Returning empty cart and exiting');
            setCart({cartItems: []})
            setError(false)
            return
        }
        
        const headers = authHeader()
        const url = `${API_BASE_URL}/api/cart-service/cart/get/byUser`
        
        console.log('Step 6 - Computed URL:', url);
        console.log('Step 7 - Auth headers:', JSON.stringify(headers, null, 2));
        console.log('Step 8 - About to make axios.get() call...');
        console.log('============================================\n');
        
        setProcessing(true)
        try {
            const response = await axios.get(url, { headers })
            console.log('>>> CART FETCH SUCCESS:', response.data);
            setError(false)
            setCart(response.data.response)
        } catch (error) {
            console.error('\n========== CART FETCH FAILED ==========');
            console.error('Error type:', error.constructor.name);
            console.error('Error message:', error.message);
            console.error('Is Network Error:', error.message === 'Network Error');
            console.error('Has response:', !!error.response);
            if (error.response) {
                console.error('Response status:', error.response.status);
                console.error('Response statusText:', error.response.statusText);
                console.error('Response data:', error.response.data);
                console.error('Response headers:', error.response.headers);
            }
            console.error('========================================\n');
            setCart({cartItems:[]})
            setError(true)
        }
        setProcessing(false)
    }

     useEffect(() => {
        // Listen for custom user change events
        const handleUserChange = () => {
            setUserToken(localStorage.getItem("user"))
        }
        
        window.addEventListener('userChanged', handleUserChange)
        
        // Initial load
        getCartInformation()
        
        return () => {
            window.removeEventListener('userChanged', handleUserChange)
        }
     }, [])

    return { cart, cartError, isProcessingCart, addItemToCart, updateItemQuantity, removeItemFromCart, getCartInformation };

}

export default CartService;