export default function (val) {
  if (val) {
    let date = null;
    if (typeof val.getMonth === 'function') {
      date = val;
    } else {
      date = new Date(val);
    }
    if (!isNaN(date.getTime())) {
      var yyyy = date.getFullYear().toString();
      var mm = (date.getMonth() + 1).toString(); // getMonth() is zero-based
      var dd = date.getDate().toString();
      return mm + '/' + dd + '/' + yyyy; // padding
    }
    return null;
  }
  return null;
}
