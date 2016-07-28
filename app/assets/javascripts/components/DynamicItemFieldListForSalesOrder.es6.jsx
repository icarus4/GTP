var DynamicItemFieldListForSalesOrder = React.createClass({
  getInitialState: function() {
    return {
      maxItemFieldId: 0,
      itemFields: [{id: 0, quantity: null, unitPrice: null, itemId: null, note: ""}],
      // availableItems: [],
    };
  },
  loadItemsFromServer: function() {
    $.ajax({
      url: "/api/v1/items",
      dataType: 'json',
      type: 'GET',
      cache: false,
      success: function(data) {
        this.setState({availableItems: data.items});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(status, err.toString());
      }.bind(this)
    });
  },
  componentWillMount: function() {
    // this.loadItemsFromServer();
  },
  handleClickAddItemButton: function() {
    var itemFields = this.state.itemFields;
    var nextItemFieldId = this.state.maxItemFieldId + 1;
    itemFields.push({id: nextItemFieldId});
    this.setState({maxItemFieldId: nextItemFieldId});
  },
  handleClickRemoveButton: function(id) {
    var itemFields = this.state.itemFields;
    for (var i = 0; i < itemFields.length; i++) {
      if (itemFields[i].id == id) {
        itemFields.splice(i, 1);
        break;
      }
    }
    this.setState({itemFields: itemFields});
    this.props.onDynamicItemFieldListChange(itemFields);
  },
  handleItemFieldChange: function(item) {
    var itemFields = this.state.itemFields;
    // Modify object in itemFields array if input item is in the itemFields array
    // Otherwise add this input item to itemFields array
    for (var i = 0; i < itemFields.length; i++) {
      if (itemFields[i].id == item.id) {
        itemFields[i].quantity  = item.quantity;
        itemFields[i].unitPrice = item.unitPrice;
        itemFields[i].itemId    = item.itemId;
        itemFields[i].note      = item.note;
        this.setState({itemFields: itemFields});
        this.props.onDynamicItemFieldListChange(itemFields);
        return;
      }
    }
    itemFields.push(item);
    this.setState({itemFields: itemFields});
    this.props.onDynamicItemFieldListChange(itemFields);
  },
  render: function() {
    var availableItems = this.props.availableItems;
    var handleClickRemoveButton = this.handleClickRemoveButton;
    var itemFieldNodes = this.state.itemFields.map(function(itemField) {
      return (
        <div key={"item-field-" + itemField.id}>
          <ItemField onItemFieldChange={this.handleItemFieldChange} key={itemField.id} id={itemField.id} items={availableItems} label="選擇貨品" />
          <button
            key={"remove-button-" + itemField.id}
            type="button"
            className="btn btn-default btn-xs"
            onClick={handleClickRemoveButton.bind(null, itemField.id)}>
            x
          </button>
        </div>
      );
    }, this);
    return (
      <div id="itemList">
        {itemFieldNodes}
        <br />
        <span className="label label-primary" onClick={this.handleClickAddItemButton}>+貨品</span>
      </div>
    );
  }
});
