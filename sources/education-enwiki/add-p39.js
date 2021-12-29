module.exports = (id, startdate, enddate) => {
  qualifier = { }
  if(startdate) qualifier['P580'] = startdate
  if(enddate)   qualifier['P582'] = enddate

  return {
    id,
    claims: {
      P39: {
        value: 'Q967762',
        qualifiers: qualifier,
        references: { P4656: 'https://en.wikipedia.org/wiki/United_States_Secretary_of_Education' }
      }
    }
  }
}
