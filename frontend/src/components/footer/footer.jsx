import CopyRight from './copyright';
import Signature from './Signature';
import './footer.css'

function Footer() {
    

    return (
        <>
            <footer>
                <div>
                    <h1>News letter</h1>
                    <p>Stay tuned with us!</p>
                    <input type='text' placeholder='Enter your email'/>
                    <button>Submit</button>
                </div>

                <div>
                    <h1>Jathin's Digital Marketplace</h1>
                    <p>We build high-performance, scalable digital commerce solutions. JNexus Commerce is engineered with modern microservices architecture to deliver a seamless shopping experience.</p>
                    <button>Learn more</button>
                </div>


                <div>
                    <h1>Contact Us</h1>
                    <div>
                        <p><span><i className="fa fa-map-marker"></i></span>Bangalore, India</p>
                        <p><span><i className="fa fa-phone"></i></span>+91 9876543210</p>
                        <p><span><i className="fa fa-envelope"></i></span>jathinsahu@gmail.com</p>
                    </div>
                    <p>
                        <span><i className="fa fa-facebook"></i></span>
                        <span><i className="fa fa-twitter"></i></span>
                        <span><i className="fa fa-instagram"></i></span>
                        <span><i className="fa fa-youtube"></i></span>
                    </p>
                </div>
            </footer>
            <CopyRight />
            <Signature />
        </>
    )
}

export default Footer;