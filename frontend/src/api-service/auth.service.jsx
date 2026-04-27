import { useState } from "react"
import apiClient from './apiClient';
import { useNavigate } from "react-router-dom";

function AuthService() {
    const [isLoading, setLoading] = useState(false);
    const [response, setResponse] = useState(null);
    const [error, setError] = useState(null);
    const navigate = useNavigate();

    const login = async (email, password) => {
        console.log(email, password)
        setLoading(true)
        try {
            const response = await apiClient.post('/auth-service/auth/signin', { email: email, password: password });
            if (response.data.response.token) {
                setResponse(true);
                setError(null)
                localStorage.setItem("user", JSON.stringify(response.data.response));
            }
        } catch (error) {
            console.log(error)
            setResponse(null)
            const resMessage = (error.response && error.response.data && error.response.data.message) || error.message || error.toString();
            if (resMessage == "Bad credentials") {
                setError("Invalid email or password!");
            } else {
                setError("Unable to perform login now. Try again later!");
            }
        }
        setLoading(false)
    }

    const save = async (userName, email, password) => {
        setLoading(true)
        try {
            const response = await apiClient.post('/auth-service/auth/signup', { userName, email, password });
            if (response.data.success) {
                setResponse(true);
                setError(null)
                navigate(`/auth/userRegistrationVerfication/${email}`);
            }
        } catch (error) {
            console.error(error)
            setResponse(null)
            if (error.response) {
                setError(error.response.data.message);
            } else {
                setError("Unable to perform register now. Try again later!");
            }
        }
        setLoading(false)
    }

    const verifyRegistration = async (verificationCode) => {
        setLoading(true)
        try {
            const response = await apiClient.get('/auth-service/auth/signup/verify', {
                params: {
                    code: verificationCode
                }
            });
            if (response.data.success) {
                setResponse(true);
                setError(null)
                navigate(`/auth/success-registration`);
            }
        } catch (error) {
            console.error(error)
            setResponse(null)
            if (error.response) {
                setError(error.response.data.message);
            } else {
                setError("Unable to perform verify now. Try again later!");
            }
        }
        setLoading(false)
    }

    const resendVerificationCode = async (email) => {
        try {
            const response = await apiClient.get('/auth-service/auth/signup/resend', {
                params: {
                    email: email
                }
            });
            if (response.data.success) {
                setResponse(true);
                setError(null)
            }
        } catch (error) {
            console.error(error)
            setResponse(null)
            if (error.response) {
                setError(error.response.data.message);
            } else {
                setError("Unable to resend code now. Try again later!");
            }
        }
    }

    return {login, save, verifyRegistration, resendVerificationCode, isLoading, response, error};
}

export default AuthService;