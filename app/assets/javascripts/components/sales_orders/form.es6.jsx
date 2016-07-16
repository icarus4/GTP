var OrderNumberField = React.createClass({
  getInitialState: function() {
    return {order_number: ''}
  },
  changeOrderNumber: function(orderNumber) {
    this.setState({order_number: orderNumber});
    this.props.onOrderNumberChange(orderNumber);
  },
  handleOrderNumberChange: function(e) {
    this.changeOrderNumber(e.target.value);
  },
  loadOrderNumberFromServer: function() {
    $.ajax({
      url: this.props.nextValidOrderNumberUrl,
      dataType: 'json',
      type: 'GET',
      cache: false,
      success: function(data) {
        this.changeOrderNumber(data.next_number);
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(status, error.toString());
      }.bind(this)
    });
  },
  componentDidMount: function() {
    this.loadOrderNumberFromServer();
  },
  render: function() {
    return (
      <input
        type="text"
        placeholder="出貨單號"
        value={this.state.order_number}
        onChange={this.handleOrderNumberChange}
      />
    )
  }
});

var CustomersSelectField = React.createClass({
  getInitialState: function() {
    return {customers: [], selectedCustumerId: 0};
  },
  loadCustomersFromServer: function() {
    $.ajax({
      url: this.props.customersUrl,
      dataType: 'json',
      type: 'GET',
      cache: false,
      success: function(data) {
        this.setState({customers: data.customers});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(status, error.toString());
      }.bind(this)
    });
  },
  componentDidMount: function() {
    this.loadCustomersFromServer();
  },
  handleCustomerChange: function(e) {
    this.setState({selectedCustumerId: e.target.value});
    this.props.onCustomerChange({id: e.target.value});
  },
  render: function() {
    var optionNodes = this.state.customers.map(function(customer) {
      return (
        <option key={customer.id} value={customer.id}>{customer.name}</option>
      );
    });
    return (
      <select value={this.state.selectedCustumerId} onChange={this.handleCustomerChange}>
        <option key="0" value="0" disabled> -- 選取客戶 -- </option>
        {optionNodes}
      </select>
    );
  }
});

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

var DateField = React.createClass({
  getInitialState: function() {
    return {date: this.props.defaultValue};
  },
  handleDateChange: function(e) {
    this.setState({date: e.target.value});
    this.props.onDateChange(e.target.value);
  },
  render: function() {
    return(
      <input value={this.state.date} type="date" onChange={this.handleDateChange} />
    );
  }
});

var ItemField = React.createClass({
  getInitialState: function() {
    return {quantity: null, unitPrice: null, itemId: 0, subtotal: 0};
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
    this.props.onItemFieldChange({id: this.props.id, quantity: e.target.value, unitPrice: this.state.unitPrice, itemId: this.state.itemId});
  },
  handlePriceChange: function(e) {
    this.setState({unitPrice: e.target.value}, this.updateSubtotal);
    this.props.onItemFieldChange({id: this.props.id, quantity: this.state.quantity, unitPrice: e.target.value, itemId: this.state.itemId});
  },
  handleItemChange: function(e) {
    this.setState({itemId: e.target.value}, this.updateSubtotal);
    this.props.onItemFieldChange({id: this.props.id, quantity: this.state.quantity, unitPrice: this.state.unitPrice, itemId: e.target.value});
  },
  render: function() {
    var optionNodes = this.props.items.map(function(item) {
      return (
        <option key={item.id} value={item.id}>{item.name}</option>
      )
    })
    return(
      <div>
        {this.props.label ? (<label>{this.props.label}</label>) : null}
        <select value={this.state.itemId} onChange={this.handleItemChange}>
          <option key="0" value="0" disabled> -- 選取貨品 -- </option>
          {optionNodes}
        </select>
        <label>數量</label><input onChange={this.handleQuantityChange} type="number" min="1" style={{width: '60px'}} />
        <label>單價</label><input onChange={this.handlePriceChange} type="number" min="0" style={{width: '100px'}} />
        <label>小計:</label><span>{this.state.subtotal}元</span>
      </div>
    )
  }
});

var DynamicItemFieldList = React.createClass({
  getInitialState: function() {
    return {
      maxItemFieldId: 0,
      itemFields: [{id: 0, quantity: null, unitPrice: null, itemId: null}],
      availableItems: [],
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
    this.loadItemsFromServer();
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
        itemFields[i].quantity = item.quantity;
        itemFields[i].unitPrice = item.unitPrice;
        itemFields[i].itemId = item.itemId;
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
    var availableItems = this.state.availableItems;
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

var SalesOrderForm = React.createClass({
  getInitialState: function() {
    return {
      orderNumber: '',
      locations: [],
      shipFromLocations: [],
      customer: {},
      disableLocationSelectField: true,
      clicked: false,
      shipToLocation: {},
      billToLocation: {},
      shipFromLocation: {},
      items: [],
      shippedOn: '2016-08-31'
    }
  },
  componentDidMount: function() {
    this.loadShipFromLocationsFromServer();
  },
  defaultShippedOn: function() {
    return this.state.shippedOn;
  },
  handleSubmit: function(e) {
    e.preventDefault();
    var inputData = {
      orderNumber:      this.state.orderNumber.trim(),
      customer:         this.state.customer,
      shipToLocation:   this.state.shipToLocation,
      billToLocation:   this.state.billToLocation,
      shipFromLocation: this.state.shipFromLocation,
      shippedOn:        this.state.shippedOn,
      items:            this.state.items,
    };

    // Check input values
    if (_.isEmpty(inputData.orderNumber))      {return;}
    if (_.isEmpty(inputData.customer))         {return;}
    if (_.isEmpty(inputData.shipToLocation))   {return;}
    if (_.isEmpty(inputData.billToLocation))   {return;}
    if (_.isEmpty(inputData.shipFromLocation)) {return;}
    if (_.isEmpty(inputData.shippedOn))        {return;}
    if (_.isEmpty(inputData.items))            {return;}
    for (var i = 0; i < inputData.items.length; i++) {
      if (_.isEmpty(inputData.items[i].unitPrice))    {return;}
      if (_.isEmpty(inputData.items[i].quantity)) {return;}
    }

    // POST to server
    $.ajax({
      url: '/api/v1/sales_orders',
      dataType: 'json',
      type: 'POST',
      data: inputData,
      success: function(data) {
        console.log(data)
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  handleCustomerChange: function(customer) {
    this.setState({
      customer: customer,
      disableLocationSelectField: false
    });
    $.ajax({
      url: "/api/v1/customers/" + customer.id + "/locations",
      dataType: 'json',
      type: 'GET',
      cache: false,
      success: function(data) {
        this.setState({locations: data.locations});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(status, err.toString());
      }.bind(this)
    });
  },
  handleOrderNumberChange: function(orderNumber) {
    this.setState({orderNumber: orderNumber})
  },
  loadShipFromLocationsFromServer: function() {
    $.ajax({
      url: "/api/v1/locations",
      dataType: 'json',
      type: 'GET',
      cache: false,
      success: function(data) {
        this.setState({shipFromLocations: data.locations});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(status, err.toString());
      }.bind(this)
    });
  },
  handleShipToLocationChange: function(location) {
    this.setState({shipToLocation: {id: location.id}});
  },
  handleReceiptLocationChange: function(location) {
    this.setState({billToLocation: {id: location.id}});
  },
  handleShipFromLocationChange: function(location) {
    this.setState({shipFromLocation: {id: location.id}});
  },
  handleDateChange: function(dateString) {
    this.setState({shippedOn: dateString});
  },
  handleDynamicItemFieldListChange: function(items) {
    this.setState({items: items});
  },
  render: function() {
    return(
      <form className="salesOrderForm" onSubmit={this.handleSubmit}>
        <div>
          <label>出貨單單號</label>
          <OrderNumberField
            nextValidOrderNumberUrl="/api/v1/sales_orders/next_number"
            onOrderNumberChange={this.handleOrderNumberChange}
          />
        </div>
        <br />
        <div>
          <label>收貨客戶</label>
          <CustomersSelectField
            customersUrl='/api/v1/customers'
            onCustomerChange={this.handleCustomerChange}
          />
        </div>
        <br />
        <div>
          <label>寄貨至：</label>
          <LocationsSelectField
            disabled={this.state.disableLocationSelectField}
            locations={this.state.locations}
            onLocationChange={this.handleShipToLocationChange}
          />
        </div>
        <br />
        <div>
          <label>寄發票至：</label>
          <LocationsSelectField
            disabled={this.state.disableLocationSelectField}
            locations={this.state.locations}
            onLocationChange={this.handleReceiptLocationChange}
          />
        </div>
        <br />
        <div>
          <label>出貨地點</label>
          <LocationsSelectField
            disabled={false}
            locations={this.state.shipFromLocations}
            onLocationChange={this.handleShipFromLocationChange}
          />
        </div>
        <br />
        <div>
          <label>出貨日期</label>
          <DateField defaultValue={this.defaultShippedOn()} onDateChange={this.handleDateChange} />
        </div>
        <br />
        <DynamicItemFieldList onDynamicItemFieldListChange={this.handleDynamicItemFieldListChange} />
        <br />
        <div>
          <input type="submit" value="儲存出貨單" />
        </div>
      </form>
    );
  }
});
