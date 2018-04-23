import ForEach from 'lodash/forEach'

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

  data(data = this.originalData, formData = new FormData(), namespace = []) {
    let formKey;
    let value;
    let newFormKey;
    let newValue;

    ForEach(namespace, (name) => {
      formKey = (formKey || '') + '[' + name + ']'
      value = (value || this)[name]
    })

    for (let field in data) {
      if (data.hasOwnProperty(field)) {

        if (namespace.length > 0) {
          newFormKey = formKey + '[' + field + ']'
          newValue = value[field]
        } else {
          newFormKey = field
          newValue = this[field]
        }


        if (typeof newValue === 'object'
            && newValue != null
            && !(newValue instanceof File)) {

          let newNamespace = namespace.slice(0)
          newNamespace.push(field)

          this.data(newValue, formData, newNamespace)
        } else {
          formData.append(newFormKey, newValue)
        }
      }
    }

    return formData
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
