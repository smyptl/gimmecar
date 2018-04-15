import Moment from 'moment'
import IsNil from 'lodash/isNil'

export default function (val) {
  if (IsNil(val)) {
    return null;
  }

  var val = Moment(val)

  if (val.isValid()) {
    return val.format('M/D/YYYY')
  }
  return null;
}
