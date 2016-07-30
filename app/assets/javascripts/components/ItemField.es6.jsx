var ItemField = React.createClass({
  getInitialState: function() {
    return {quantity: null, unitPrice: null, itemId: 0, subtotal: 0, note: ""};
  },
  updateSubtotal: function() {
    if (this.state.quantity && this.state.unitPrice) {
      var subtotal = parseInt(this.state.quantity) * parseInt(this.state.unitPrice);
      this.setState({subtotal: subtotal});
    }
    else {
      this.setState({subtotal: 0});
    }
  },
  handleQuantityChange: function(e) {
    this.setState({quantity: e.target.value}, this.updateSubtotal);
    this.props.onItemFieldChange({id: this.props.id, quantity: e.target.value, unitPrice: this.state.unitPrice, itemId: this.state.itemId, note: this.state.note});
  },
  handlePriceChange: function(e) {
    this.setState({unitPrice: e.target.value}, this.updateSubtotal);
    this.props.onItemFieldChange({id: this.props.id, quantity: this.state.quantity, unitPrice: e.target.value, itemId: this.state.itemId, note: this.state.note});
  },
  handleItemChange: function(e) {
    this.setState({itemId: e.target.value}, this.updateSubtotal);
    this.props.onItemFieldChange({id: this.props.id, quantity: this.state.quantity, unitPrice: this.state.unitPrice, itemId: e.target.value, note: this.state.note});
  },
  handleNoteChange: function(e) {
    note = e.target.value.trim();
    this.setState({note: note});
    this.props.onItemFieldChange({id: this.props.id, quantity: this.state.quantity, unitPrice: this.state.unitPrice, itemId: this.state.itemId, note: note})
  },
  render: function() {
    var optionNodes = null;
    if (this.props.items) {
      optionNodes = this.props.items.map(function(item) {
        return (
          <option key={item.id} value={item.id}>{item.name} (剩餘數量: {item.available_count})</option>
        )
      });
    }

    var selectedItemDetail = null;
    if (this.state.itemId > 0) {
      var items = this.props.items;
      var _this = this;
      selectedItem = _.find(items, function(item) {return item.id == _this.state.itemId});
      selectedItemDetail = selectedItem.variants.map(function(variant) {
        return (
          <span key={variant.id}>倉庫現有數量:{variant.quantity} 過期日:{variant.expiry_date}</span>
        )
      });
    }

    return(
      <div>
        {this.props.label ? (<label>{this.props.label}</label>) : null}
        <select value={this.state.itemId} onChange={this.handleItemChange}>
          <option key="0" value="0" disabled> -- 選取貨品 -- </option>
          {optionNodes}
        </select>
        <span> 數量</span><input onChange={this.handleQuantityChange} type="number" min="1" style={{width: '60px'}} />
        <span> 單價</span><input onChange={this.handlePriceChange} type="number" min="0" style={{width: '100px'}} />
        <span> 小計:</span><span>{this.state.subtotal}元</span>
        <span> 備註:</span><input onChange={this.handleNoteChange} type="text" style={{width: '250px'}}/>
        <br />
        {selectedItemDetail}
      </div>
    )
  }
});
