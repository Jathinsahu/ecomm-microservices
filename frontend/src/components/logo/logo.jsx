import './logo.css'
import {Link} from 'react-router-dom'

function Logo() {
    return <Link to='/'><h1 className='logo'><span></span>JS Premium</h1></Link>
}

export default Logo;