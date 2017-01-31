import Moment from 'moment'

export default function (val) {
  var val = Moment(val)

  if (val.isValid()) {
    return val.format('M/D/YYYY')
  }
  return null;
}
