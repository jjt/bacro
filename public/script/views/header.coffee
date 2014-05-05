R = React.DOM
module.exports = React.createClass
  displayName: 'Header'
  getDefaultProps: ()->
    siteTitle: 'BACRO'
    breadCrumbs: []

  render: ()->
    R.div className: 'container', [
      R.div className:'row', [
        R.div className:'col-xs-12', [
          R.ul className:'breadcrumb', [
            R.li {}, R.a className:'siteTitle', href:'/', @props.siteTitle
            @props.breadCrumbs.map (el)=>
              R.li {}, R.a className: 'disabled', el
          ]
        ]
      ]
    ]
