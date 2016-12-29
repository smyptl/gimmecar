export default function (val) {
  if (val || val === 0) {
    val = parseFloat(val) / 100
    return '$' + val.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  }
  return '';
}
