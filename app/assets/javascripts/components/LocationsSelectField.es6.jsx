var LocationsSelectField = React.createClass({
  getInitialState: function() {
    return {selectedLocationId: 0}
  },
  handleLocationChange: function(e) {
    this.setState({selectedLocationId: e.target.value});
    this.props.onLocationChange({id: e.target.value});
  },
  render: function() {
    var optionNodes = this.props.locations.map(function(location) {
      return (
        <option key={location.id} value={location.id}>{location.name}</option>
      );
    });
    return (
      <select value={this.state.selectedLocationId} disabled={this.props.disabled} onChange={this.handleLocationChange}>
        <option value="0" disabled> -- 選取地點 -- </option>
        {optionNodes}
      </select>
    );
  }
});
