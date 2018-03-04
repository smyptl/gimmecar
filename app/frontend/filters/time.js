import Moment from 'moment'

export default function (val) {
  var val = Moment(val)

  if (val.isValid()) {
    return val.format('MMM Do, YYYY @ h:mm A')
  }
  return null;
}
