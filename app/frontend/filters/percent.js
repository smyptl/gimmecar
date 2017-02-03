export default function (val, decimal_places) {
  if (val || val === 0) {
    val = val * 100;
    if (decimal_places || decimal_places === 0) {
      val = parseFloat(val).toFixed(decimal_places);
    }
    return val + '%';
  }
  return null;
}
