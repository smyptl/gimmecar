import { mount } from '@vue/test-utils';
import InputCurrency from 'components/inputs/currency.vue';

describe('InputCurrency', () => {
  it('changes value to formatted currency', () => {
    const wrapper = mount(InputCurrency)
    wrapper.setProps({ value: 10000 })

    expect(wrapper.vm.formatted).toBe('$100.00');
    expect(wrapper.vm.value).toBe(10000);
  });

  it('on parseValue emits new value and formats correctly', () => {
    const wrapper = mount(InputCurrency)
    wrapper.setProps({ value: '' })

    expect(wrapper.vm.formatted).toBe('')

    wrapper.vm.formatted = '100.0'
    wrapper.vm.parseCurrency()

    expect(wrapper.vm.formatted).toBe('$100.00')
    expect(wrapper.emitted().input).toEqual([[10000]])
  });

  it('on parseValue emits new value and formats correctly', () => {
    const wrapper = mount(InputCurrency)
    wrapper.vm.formatted = '$20.0'
    wrapper.vm.parseCurrency()

    expect(wrapper.vm.formatted).toBe('$20.00')
    expect(wrapper.emitted().input).toEqual([[2000]])
  });
})
