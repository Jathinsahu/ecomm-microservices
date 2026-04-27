import { useContext } from 'react';
import { AuthContext } from '../../contexts/auth.context';
import './hero.css'
import {Link} from 'react-router-dom'

function Hero() {
    
    const {user, toggleUser} = useContext(AuthContext)

    return(
        <section className="hero-section" id='hero'>
            <h1>Upgrade Your Tech Lifestyle with JKart.</h1>
            <h3>Discover the latest in innovation. From flagship smartphones to immersive gaming consoles, we bring the future to your doorstep with premium quality and unbeatable speed.</h3>
            <div>
                <Link to='/products/All'><button>Shop now</button></Link>
                
            </div>
        </section>
    )
}



export default Hero;