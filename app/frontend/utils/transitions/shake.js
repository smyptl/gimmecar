import Snabbt from 'snabbt.js'

export default function (el) {
  Snabbt(el, 'attention', {
    position: [50, 0, 0],
    springConstant: 2.4,
    springDeceleration: 0.9,
  })
}
