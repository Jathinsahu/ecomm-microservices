import { useState } from "react"
import apiClient from './apiClient';

function ProductService() {
    const [isLoading, setLoading] = useState(false);
    const [categories, setCategories] = useState([]);
    const [products, setProducts] = useState([]);
    const [error, setError] = useState(false);

    const getAllCategories = async () => {
        setLoading(true)
        try {
            const response = await apiClient.get('/category-service/category/get/all');
            setCategories(response.data.response);
            setError(false);
        } catch (error) {
            setCategories([]);
            setError(true);
        }
        setLoading(false);
    }

    const getAllProducts = async () => {
        setLoading(true)
        setProducts([])
        try {
            const response = await apiClient.get('/product-service/product/get/all');
            setProducts(response.data.response);
            setError(false);
        } catch (error) {
            setProducts([]);
            setError(true);
        }
        setLoading(false);
    }

    const getProductsByCategory = async (id) => {
        setLoading(true)
        try {
            const response = await apiClient.get('/product-service/product/get/byCategory', {
                params: {
                    id: id
                }
            });
            setProducts(response.data.response);
            setError(false);
        } catch (error) {
            setProducts([]);
            setError(true);
        }
        setLoading(false);
    }

    const searchProducts = async (key) => {
        setLoading(true)
        try {
            const response = await apiClient.get('/product-service/product/search', {
                params: {
                    searchKey: key
                }
            });
            setProducts(response.data.response);
            setError(false);
        } catch (error) {
            setProducts([]);
            setError(true);
        }
        setLoading(false);
    }

    return {getAllCategories, getAllProducts, getProductsByCategory, searchProducts, isLoading, categories, products, error};
}

export default ProductService;