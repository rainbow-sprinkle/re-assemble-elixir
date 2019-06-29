import React from "react"
import PropTypes from "prop-types"

class TimelineTickmarks extends React.Component {
  render() {
    return <div className="__tickmarksContainer">
      {this.renderTickmarksEvery1Second()}
      {this.renderLabelsEvery5Seconds()}
      {/* (TODO: make the tickmark granularity conditional on zoom) */}
    </div>
  }

  renderTickmarksEvery1Second() {
    if (this.props.timelineZoom < 5) return
    let output = []

    for (let sec = 1; sec < this.props.videoDuration; sec ++) {
      if (sec % 5 == 0) continue
      let style = {left: ""+(sec * this.props.timelineZoom)+"px"}
      output.push(<div key={sec} className="__tickmark --minor" style={style}></div>)
    }

    return output
  }

  renderLabelsEvery5Seconds() {
    let output = []

    for (let sec = 5; sec < this.props.videoDuration; sec += 5) {
      if (this.props.timelineZoom < 5 && sec % 20 != 0) continue
      if (this.props.timelineZoom < 1 && sec % 60 != 0) continue

      let m = Math.floor(sec / 60)
      let s = (sec % 60)
      s = ("00" + s).substr(-2, 2) // zeropad

      let tickmarkStyle = {left: ""+(sec * this.props.timelineZoom)+"px"}
      output.push(<div key={sec+"tick"} className="__tickmark --major" style={tickmarkStyle}></div>)

      let labelStyle = {left: ""+(sec * this.props.timelineZoom-10)+"px"}
      output.push(<div key={sec+"label"} className="__tickLabel" style={labelStyle}>{m+":"+s}</div>)
    }

    return output
  }
}

TimelineTickmarks.propTypes = {
  videoDuration: PropTypes.number.isRequired,
  timelineZoom: PropTypes.number.isRequired
}

export default TimelineTickmarks
