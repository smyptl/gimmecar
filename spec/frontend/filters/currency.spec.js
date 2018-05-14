import Currency from 'filters/currency.js';

describe('Currency', () => {
  it('returns 0 when value is 0', () => {
    expect(Currency(0)).toBe('$0.00');
  });

  it('returns null when value is not a number', () => {
    expect(Currency(null)).toBe('');
  });

  it('adds commas and two decimals places', () => {
    expect(Currency(967056)).toBe('$9,670.56');
  });

  it('does not add decimals if integer', () => {
    expect(Currency(1000)).toBe('$10.00');
  });
});
