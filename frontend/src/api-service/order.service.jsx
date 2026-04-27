import { useState } from "react"
import apiClient from './apiClient';
import { useNavigate } from "react-router-dom";

function OrderService() {
    const [orderError, setError] = useState(null);
    const [isLoading, setLoading] = useState(false);
    const [userOrders, setUserOrders] = useState([])
    const user = JSON.parse(localStorage.getItem("user"));
    const navigate = useNavigate()

    const placeOrder = async ({ fname, lname, address1, address2, city, phone }, cart) => {
        setLoading(true)
        try {
            const response = await apiClient.post('/order-service/order/create', {
                firstName: fname, lastName: lname, addressLine1: address1, addressLine2: address2, city: city, phoneNo: phone, cartId: cart
            });
            setError(null)
            console.log(response)
            navigate("/order/success")
        } catch (error) {
            console.log(error)
            setError(error.response.data.message)
        }
        setLoading(false)
    };

    const getOrdersByUser = async () => {
        setLoading(true)
        try {
            const response = await apiClient.get('/order-service/order/get/byUser');
            setError(null)
            setUserOrders(response.data.response)
        } catch (error) {
            console.log(error)
            setUserOrders([])
        }
        setLoading(false)
    };

    return { isLoading, orderError, userOrders, getOrdersByUser, placeOrder };

}

export default OrderService;