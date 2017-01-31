import Axios from 'axios'
Axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
Axios.defaults.headers.common['X-CSRF-Token'] = document.getElementsByName('csrf-token')[0].content

export default Axios
