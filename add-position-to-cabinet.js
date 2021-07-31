module.exports = (id) => ({
  id,
  claims: {
    P361: {
      value: 'Q639738',
      references: {
        P854: 'https://www.whitehouse.gov/administration/cabinet/',
        P1476: {
          text: 'The Cabinet',
          language: 'en',
        },
        P813: new Date().toISOString().split('T')[0],
        P407: 'Q1860', // language: English
      }
    }
  }
})
