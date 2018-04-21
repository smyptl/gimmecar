class Errors {

  constructor() {
    this.errors = {}
  }

  has(field) {
    return this.errors.hasOwnProperty(field)
  }

  any() {
    return Object.keys(this.errors).length > 0
  }

  get(field) {
    if (this.errors[field])  {
      return this.errors[field]
    }
  }

  record(errors) {
    this.errors = errors
  }

  clear(field) {
    if (field) {
      delete this.errors[field]

      return
    }

    this.errors = {}
  }
}

export default class Form {

  constructor(data) {
    this.originalData = data

    for (let field in data) {
      this[field] = data[field]
    }

    this.errors = new Errors()
  }

  data(namespace = null) {
    let data = new FormData()

    for (let property in this.originalData) {
      data.append(property, this[property])
    }

    return data
  }

  toFormData() {

  }

  populate(data) {
    for (let field in data) {
      this[field] = data[field]
    }

    return data
  }

  reset() {
    for (let field in this.originalData) {
      this[field] = ''
    }

    this.errors.clear()
  }
}
