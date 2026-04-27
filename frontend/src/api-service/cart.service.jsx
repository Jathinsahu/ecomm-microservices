import { useState, useEffect } from "react"
import apiClient from './apiClient';

function CartService() {
    const [cart, setCart] = useState({})
    const [cartError, setError] = useState(false);
    const [isProcessingCart, setProcessing] = useState(false);
    const user = JSON.parse(localStorage.getItem("user"));

    const addItemToCart = async (productId, quantity) => {
        setProcessing(true)
        try {
            await apiClient.post('/cart-service/cart/add', { productId, quantity });
            setError(false);
        } catch (error) {
            setError(true);
        }
        setProcessing(false)
        getCartInformation()
    }

    const updateItemQuantity = async (productId, quantity) => {
        setProcessing(true)
        try {
            await apiClient.post('/cart-service/cart/add', { productId, quantity });
            setError(false);
        } catch (error) {
            setError(true);
        }
        setProcessing(false)
        getCartInformation()
    }

    const removeItemFromCart = async (productId) => {
        setProcessing(true)
        try {
            await apiClient.delete('/cart-service/cart/remove', {
                params: {
                    productId: productId
                }
            });
            setError(false);
        } catch (error) {
            setError(true);
        }
        getCartInformation()
    }

    const getCartInformation = async () => {
        if (!user?.token) {
            setCart({})
            setError(false)
            return
        }
        setProcessing(true)
        try {
            const response = await apiClient.get('/cart-service/cart/get/byUser');
            setError(false)
            setCart(response.data.response)
        } catch (error) {
            setCart({cartItems:[]})
            setError(true)
        }
        setProcessing(false)
    }

     useEffect(() => {
        getCartInformation()
     }, [])

    return { cart, cartError, isProcessingCart, addItemToCart, updateItemQuantity, removeItemFromCart, getCartInformation };

}

export default CartService;