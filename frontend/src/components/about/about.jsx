import './about.css'

function About() {
    return (
        <section class="about">
            <div className="about-image"><h3>Ready to level up your gear?</h3></div>
            <div class="about-content">
                <h1>Who we are?</h1>
                <p>Welcome to JKart, your ultimate destination for cutting-edge technology and premium electronics. We are committed to bringing you the latest gadgets that redefine the way you live, work, and play.</p>
                <p>At JKart, our mission is simple: to make high-end technology accessible to everyone. We meticulously curate our collection to ensure every product—from powerful gaming consoles to sleek wearables—meets our rigorous standards for performance and design.</p>
                <p>Whether you're looking for the newest flagship smartphone, a high-performance Xbox, a stylish smartwatch, or crystal-clear earbuds, JKart has you covered. Explore our wide range of tech essentials and experience the future of digital shopping today.</p>
                <div class="icon-container">
                    <div class="icon">
                        <i class="fa-solid fa-truck-fast"></i>
                        <span>Island wide Delivery</span>
                    </div>

                    <div class="icon">
                        <i class="fa-regular fa-credit-card"></i>
                        <span>Secure payments</span>
                    </div>

                    <div class="icon">
                        <i class="fa-solid fa-hand-holding-dollar"></i>
                        <span>Affordable price</span>
                    </div>

                    <div class="icon">
                        <i class="fa-solid fa-microchip"></i>
                        <span>Latest Technology</span>
                    </div>
                </div>
            </div>

        </section>
    )
}

export default About