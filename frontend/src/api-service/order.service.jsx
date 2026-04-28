import { useState, useEffect } from "react"
import API_BASE_URL from "./apiConfig";
import axios from 'axios';
import { useNavigate } from "react-router-dom";

function OrderService() {
    const [orderError, setError] = useState(null);
    const [isLoading, setLoading] = useState(false);
    const [userOrders, setUserOrders] = useState([])
    const [userToken, setUserToken] = useState(localStorage.getItem("user"));
    const navigate = useNavigate()

    const user = userToken ? JSON.parse(userToken) : null;

    const authHeader = () => {
        if (!user?.token) return {};
        const tokenType = user?.type?.trim() || 'Bearer';
        return { Authorization: `${tokenType} ${user?.token}` };
    }

    const placeOrder = async ({ fname, lname, address1, address2, city, phone }, cart) => {
        setLoading(true)
        await axios.post(`${API_BASE_URL}/api/order-service/order/create`,
            { firstName: fname, lastName: lname, addressLine1: address1, addressLine2: address2, city: city, phoneNo: phone, cartId: cart },
            { headers: authHeader() }
        ).then((response) => {
            setError(null)
            console.log(response)
            navigate("/order/success")
        }).catch((error) => {
            console.log(error)
            setError(error.response.data.message)
        });

        setLoading(false)

    };

    const getOrdersByUser = async () => {
        if (!user?.token) {
            setUserOrders([])
            setError(null)
            return
        }
        setLoading(true)
        try {
            const response = await axios.get(
                `${API_BASE_URL}/api/order-service/order/get/byUser`,
                { headers: authHeader() }
            )
            setError(null)
            setUserOrders(response.data.response)
        } catch (error) {
            console.error('Orders error:', error)
            setUserOrders([])
        }
        setLoading(false)
    };

    useEffect(() => {
        // Listen for custom user change events
        const handleUserChange = () => {
            setUserToken(localStorage.getItem("user"))
        }
        
        window.addEventListener('userChanged', handleUserChange)
        
        // Initial load
        getOrdersByUser()
        
        return () => {
            window.removeEventListener('userChanged', handleUserChange)
        }
    }, [])

    return { isLoading, orderError, userOrders, getOrdersByUser, placeOrder };

}

export default OrderService;