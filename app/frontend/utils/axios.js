import Axios from 'axios'

Axios.defaults.headers['X-Requested-With'] = 'XMLHttpRequest'
Axios.defaults.headers['X-CSRF-Token'] = document.getElementsByName('csrf-token')[0].content
Axios.defaults.headers['Content-Type'] = 'multipart/form-data'

export default Axios
