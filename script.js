// document.addEventListener("DOMContentLoaded", function() {
//   // Your JavaScript code here

// let productList = [
//   // { name: "Headphones", category: "electronics", price: 49.99, date: "2024-03-25" },
//   // { name: "Shirt", category: "clothing", price: 25.50, date: "2024-03-26" },
//   // { name: "Laptop", category: "electronics", price: 799.99, date: "2024-03-27" },
//   // { name: "Dress", category: "clothing", price: 69.99, date: "2024-03-28" },
//   // { name: "Speaker", category: "electronics", price: 99.99, date: "2024-03-29" },
//   // { name: "Speaker", category: "fun", price: 99999.99, date: "2024-03-19" },
// ];



productList = [ {'device_id':'1279172','device_name': 'AFG', 'username':'210070018','issue_date': "2024-03-15", 'return_date':"2024-03-20", 'location':'Jaipur'},
{'device_id':'123456','device_name': 'AFG', 'username':'210070018', 'issue_date':"2024-03-17",'return_date':"2024-04-05", 'location':'Hostel-6'},
{'device_id':'36156215460656132', 'device_name':'AFG', 'username':'Azeem', 'issue_date':"2024-03-20",'return_date': '2024-03-23', 'location':'Himachal'},
 {'device_id':'1', 'device_name':'DSO', 'username':'210070093', 'issue_date':"2024-03-25",'return_date': '2024-04-10', 'location':'Kanjurmarg'},
 {'device_id':'10', 'device_name':'STM', 'username':'', 'issue_date':"",'return_date': '', 'location':''},
 {'device_id':'11', 'device_name':'PICO', 'username':'', 'issue_date':"",'return_date': '', 'location':''}
//  {'device_id':'1279172','device_name': 'AFG', 'username':'210070018','issue_date': "2024-03-15", 'return_date':"2024-03-20", 'location':'Jaipur'},
//  {'device_id':'123456','device_name': 'AFG', 'username':'210070018', 'issue_date':"2024-03-17",'return_date':"2024-04-05", 'location':'Hostel-6'},
//  {'device_id':'36156215460656132', 'device_name':'AFG', 'username':'Azeem', 'issue_date':"2024-03-20",'return_date': '2024-03-23', 'location':'Himachal'},
//   {'device_id':'1', 'device_name':'DSO', 'username':'210070093', 'issue_date':"2024-03-25",'return_date': '2024-04-10', 'location':'Kanjurmarg'},
//   {'device_id':'1279172','device_name': 'AFG', 'username':'210070018','issue_date': "2024-03-15", 'return_date':"2024-03-20", 'location':'Jaipur'},
//   {'device_id':'123456','device_name': 'AFG', 'username':'210070018', 'issue_date':"2024-03-17",'return_date':"2024-04-05", 'location':'Hostel-6'},
//   {'device_id':'36156215460656132', 'device_name':'AFG', 'username':'Azeem', 'issue_date':"2024-03-20",'return_date': '2024-03-23', 'location':'Himachal'},
//    {'device_id':'1', 'device_name':'DSO', 'username':'210070093', 'issue_date':"2024-03-25",'return_date': '2024-04-10', 'location':'Kanjurmarg'},
//    {'device_id':'1279172','device_name': 'AFG', 'username':'210070018','issue_date': "2024-03-15", 'return_date':"2024-03-20", 'location':'Jaipur'},
//    {'device_id':'123456','device_name': 'AFG', 'username':'210070018', 'issue_date':"2024-03-17",'return_date':"2024-04-05", 'location':'Hostel-6'},
//    {'device_id':'36156215460656132', 'device_name':'AFG', 'username':'Azeem', 'issue_date':"2024-03-20",'return_date': '2024-03-23', 'location':'Himachal'},
//     {'device_id':'1', 'device_name':'DSO', 'username':'210070093', 'issue_date':"2024-03-25",'return_date': '2024-04-10', 'location':'Kanjurmarg'},
//     {'device_id':'1279172','device_name': 'AFG', 'username':'210070018','issue_date': "2024-03-15", 'return_date':"2024-03-20", 'location':'Jaipur'},
//     {'device_id':'123456','device_name': 'AFG', 'username':'210070018', 'issue_date':"2024-03-17",'return_date':"2024-04-05", 'location':'Hostel-6'},
//     {'device_id':'36156215460656132', 'device_name':'AFG', 'username':'Azeem', 'issue_date':"2024-03-20",'return_date': '2024-03-23', 'location':'Himachal'},
//      {'device_id':'1', 'device_name':'DSO', 'username':'210070093', 'issue_date':"2024-03-25",'return_date': '2024-04-10', 'location':'Kanjurmarg'},{'device_id':'1279172','device_name': 'AFG', 'username':'210070018','issue_date': "2024-03-15", 'return_date':"2024-03-20", 'location':'Jaipur'},
//      {'device_id':'123456','device_name': 'AFG', 'username':'210070018', 'issue_date':"2024-03-17",'return_date':"2024-04-05", 'location':'Hostel-6'},
//      {'device_id':'36156215460656132', 'device_name':'AFG', 'username':'Azeem', 'issue_date':"2024-03-20",'return_date': '2024-03-23', 'location':'Himachal'},
//       {'device_id':'1', 'device_name':'DSO', 'username':'210070093', 'issue_date':"2024-03-25",'return_date': '2024-04-10', 'location':'Kanjurmarg'},{'device_id':'1279172','device_name': 'AFG', 'username':'210070018','issue_date': "2024-03-15", 'return_date':"2024-03-20", 'location':'Jaipur'},
//       {'device_id':'123456','device_name': 'AFG', 'username':'210070018', 'issue_date':"2024-03-17",'return_date':"2024-04-05", 'location':'Hostel-6'},
//       {'device_id':'36156215460656132', 'device_name':'AFG', 'username':'Azeem', 'issue_date':"2024-03-20",'return_date': '2024-03-23', 'location':'Himachal'},
//        {'device_id':'1', 'device_name':'DSO', 'username':'210070093', 'issue_date':"2024-03-25",'return_date': '2024-04-10', 'location':'Kanjurmarg'},{'device_id':'1279172','device_name': 'AFG', 'username':'210070018','issue_date': "2024-03-15", 'return_date':"2024-03-20", 'location':'Jaipur'},
//        {'device_id':'123456','device_name': 'AFG', 'username':'210070018', 'issue_date':"2024-03-17",'return_date':"2024-04-05", 'location':'Hostel-6'},
//        {'device_id':'36156215460656132', 'device_name':'AFG', 'username':'Azeem', 'issue_date':"2024-03-20",'return_date': '2024-03-23', 'location':'Himachal'},
//         {'device_id':'1', 'device_name':'DSO', 'username':'210070093', 'issue_date':"2024-03-25",'return_date': '2024-04-10', 'location':'Kanjurmarg'},{'device_id':'1279172','device_name': 'AFG', 'username':'210070018','issue_date': "2024-03-15", 'return_date':"2024-03-20", 'location':'Jaipur'},
//         {'device_id':'123456','device_name': 'AFG', 'username':'210070018', 'issue_date':"2024-03-17",'return_date':"2024-04-05", 'location':'Hostel-6'},
//         {'device_id':'36156215460656132', 'device_name':'AFG', 'username':'Azeem', 'issue_date':"2024-03-20",'return_date': '2024-03-23', 'location':'Himachal'},
//          {'device_id':'1', 'device_name':'DSO', 'username':'210070093', 'issue_date':"2024-03-25",'return_date': '2024-04-10', 'location':'Kanjurmarg'},{'device_id':'1279172','device_name': 'AFG', 'username':'210070018','issue_date': "2024-03-15", 'return_date':"2024-03-20", 'location':'Jaipur'},
//          {'device_id':'123456','device_name': 'AFG', 'username':'210070018', 'issue_date':"2024-03-17",'return_date':"2024-04-05", 'location':'Hostel-6'},
//          {'device_id':'36156215460656132', 'device_name':'AFG', 'username':'Azeem', 'issue_date':"2024-03-20",'return_date': '2024-03-23', 'location':'Himachal'},
//           {'device_id':'1', 'device_name':'DSO', 'username':'210070093', 'issue_date':"2024-03-25",'return_date': '2024-04-10', 'location':'Kanjurmarg'},{'device_id':'1279172','device_name': 'AFG', 'username':'210070018','issue_date': "2024-03-15", 'return_date':"2024-03-20", 'location':'Jaipur'},
//           {'device_id':'123456','device_name': 'AFG', 'username':'210070018', 'issue_date':"2024-03-17",'return_date':"2024-04-05", 'location':'Hostel-6'},
//           {'device_id':'36156215460656132', 'device_name':'AFG', 'username':'Azeem', 'issue_date':"2024-03-20",'return_date': '2024-03-23', 'location':'Himachal'},
//            {'device_id':'1', 'device_name':'DSO', 'username':'210070093', 'issue_date':"2024-03-25",'return_date': '2024-04-10', 'location':'Kanjurmarg'},{'device_id':'1279172','device_name': 'AFG', 'username':'210070018','issue_date': "2024-03-15", 'return_date':"2024-03-20", 'location':'Jaipur'},
//            {'device_id':'123456','device_name': 'AFG', 'username':'210070018', 'issue_date':"2024-03-17",'return_date':"2024-04-05", 'location':'Hostel-6'},
//            {'device_id':'36156215460656132', 'device_name':'AFG', 'username':'Azeem', 'issue_date':"2024-03-20",'return_date': '2024-03-23', 'location':'Himachal'},
//             {'device_id':'1', 'device_name':'DSO', 'username':'210070093', 'issue_date':"2024-03-25",'return_date': '2024-04-10', 'location':'Kanjurmarg'},{'device_id':'1279172','device_name': 'AFG', 'username':'210070018','issue_date': "2024-03-15", 'return_date':"2024-03-20", 'location':'Jaipur'},
//             {'device_id':'123456','device_name': 'AFG', 'username':'210070018', 'issue_date':"2024-03-17",'return_date':"2024-04-05", 'location':'Hostel-6'},
//             {'device_id':'36156215460656132', 'device_name':'AFG', 'username':'Azeem', 'issue_date':"2024-03-20",'return_date': '2024-03-23', 'location':'Himachal'},
//              {'device_id':'1', 'device_name':'DSO', 'username':'210070093', 'issue_date':"2024-03-25",'return_date': '2024-04-10', 'location':'Kanjurmarg'},{'device_id':'1279172','device_name': 'AFG', 'username':'210070018','issue_date': "2024-03-15", 'return_date':"2024-03-20", 'location':'Jaipur'},
//              {'device_id':'123456','device_name': 'AFG', 'username':'210070018', 'issue_date':"2024-03-17",'return_date':"2024-04-05", 'location':'Hostel-6'},
//              {'device_id':'36156215460656132', 'device_name':'AFG', 'username':'Azeem', 'issue_date':"2024-03-20",'return_date': '2024-03-23', 'location':'Himachal'},
//               {'device_id':'1', 'device_name':'DSO', 'username':'210070093', 'issue_date':"2024-03-25",'return_date': '2024-04-10', 'location':'Kanjurmarg'}
            ]


// device_id , device_name , username  , issue_date , return_date , location
let filteredList = productList;
let templist= productList;
function fetchData(){

  // fetch('http://192.168.0.119:8000/devices/')
  // .then(response =>{
  //   response.json().then((r)=>{console.log(r);
  //   let re = r;
  //    re.forEach((res)=>{
  //     productList.push({'device_id': res[0],'device_name':res[1], 'username':res[2],'issue_date':res[3], 'return_date':res[4], 'location':res[5]});
  //   });
        //filteredList = productList;
  //   displayProducts(productList);

  // });    
  // });

  displayProducts(productList);
  let templist= productList;
  filteredList = productList;

}


function countDevices() {
  return productList.length;
}

// Function to count total issued devices
function countIssuedDevices() {
  return productList.filter(device => device.username!="").length;
}

// Generate the HTML content
var totalDevicesElement = document.getElementById("totalDevices");
var totalIssuedElement = document.getElementById("totalIssued");
var totalNotissuedElement = document.getElementById("totalNotissued");

var totalDevices = countDevices();
var totalIssued = countIssuedDevices();
var totalNotissued =  totalDevices - totalIssued;

totalDevicesElement.textContent = totalDevices;
totalIssuedElement.textContent = totalIssued;
totalNotissuedElement.textContent = totalNotissued





  const productTable = document.getElementById("product-table");


  function displayProducts(filteredList) {
    productTable.innerHTML = ""; // Clear previous content

    (filteredList || productList).forEach((product) => {
      const tableRow = document.createElement("tr");

      // Create and append name cell
      const device_id = document.createElement("td");
      device_id.textContent = product.device_id;
      tableRow.appendChild(device_id);

      const device_name = document.createElement("td");
      device_name.textContent = product.device_name;
      tableRow.appendChild(device_name);

      const username = document.createElement("td");
      username.textContent = product.username;
      tableRow.appendChild(username);

      const issue_date = document.createElement("td");
      issue_date.textContent = product.issue_date;
      tableRow.appendChild(issue_date);

      const return_date = document.createElement("td");
      return_date.textContent = product.return_date;
      tableRow.appendChild(return_date);

      const location = document.createElement("td");
      location.textContent = product.location;
      tableRow.appendChild(location);


      // Append the row to the table
      productTable.appendChild(tableRow);
    });
  }


// Set to store added product names
const addedProductNames = new Set();

// Function to create checkboxes for products
function createProductCheckboxes(products) {
  const filterProductsList = document.getElementById("filter-products");

 

  // Create checkboxes for products
  products.forEach((product) => {
    // Check if the product name has already been added
    if (!addedProductNames.has(product.device_name)) {
      const listItem = document.createElement("li");
      const checkbox = document.createElement("input");
      checkbox.type = "checkbox";
      checkbox.value = product.device_name;
      checkbox.id = product.device_name.toLowerCase().replace(/\s/g, '-');
      const label = document.createElement("label");
      label.setAttribute("for", checkbox.id);
      label.textContent = product.device_name;
      listItem.appendChild(checkbox);
      listItem.appendChild(label);
      filterProductsList.appendChild(listItem);

      // Add the product name to the set
      addedProductNames.add(product.device_name);
    }
  });


   // Create "Uncheck All" checkbox
   const uncheckAllCheckbox = document.createElement("input");
   uncheckAllCheckbox.type = "checkbox";
   uncheckAllCheckbox.id = "uncheck-all-checkbox";
   const uncheckAllLabel = document.createElement("label");
   uncheckAllLabel.setAttribute("for", uncheckAllCheckbox.id);
   uncheckAllLabel.textContent = "Uncheck All";
   filterProductsList.appendChild(document.createElement("br")); // Add line break
   filterProductsList.appendChild(uncheckAllCheckbox);
   filterProductsList.appendChild(uncheckAllLabel);
   filterProductsList.appendChild(document.createElement("br")); // Add line break
 
   // Event listener for "Uncheck All" checkbox
   uncheckAllCheckbox.addEventListener("change", function() {
     const checkboxes = document.querySelectorAll("#filter-products input[type='checkbox']");
     checkboxes.forEach((checkbox) => {
       checkbox.checked = this.checked;
     });
     filterProductsByCheckboxes();
   });


}



function applyfilters(filtervalue){

  
  const startDate = document.getElementById("start-date").value;

  const endDate = document.getElementById("end-date").value;
  console.log(endDate);

  filteredList = templist.filter((product) => 
  {
    if(startDate=="" && endDate ==""){
      return true;
    }
    else if(startDate==""){
      return product.issue_date <= endDate;
    }
    else if(endDate==""){
      return product.issue_date >= startDate;
    }
    else{
      return product.issue_date >= startDate &&product.issue_date <= endDate;
    }
  }

  );
   //checkboxes
   const checkboxes = document.querySelectorAll("#filter-products input[type='checkbox']:checked");
   if (checkboxes.length != 0) {

      const selectedProducts = Array.from(checkboxes).map(checkbox => checkbox.value);
      filteredList = filteredList.filter(product => selectedProducts.includes(product.device_name));
      displayProducts(filteredList);
   }


   if(filtervalue!='nan'){
        if (filtervalue === "issued") {
          filteredList = filteredList.filter((product) => product.username!="");
        } else if (filtervalue === "not issued") {
          filteredList = filteredList.filter((product) => product.username=="");
        } 
        // else {
        //   filteredList = filteredList.filter((product) => product.category === filterValue);
        // }

   }
   displayProducts(filteredList);



}






// Populate the product checkboxes and display all products initially
createProductCheckboxes(productList);
fetchData();
  // Initial display of products
  // bydefault();







  // Filter functionality of clicking components
  document.querySelectorAll("#filter-status a").forEach((filter) => {
    filter.addEventListener("click", function (event) {
      event.preventDefault();
      const filterValue = this.getAttribute("data-filter");
      
      applyfilters(filterValue);
    });
  });


  document.getElementById("date-filter-button").addEventListener("click", function () {

  applyfilters();
  });

  document.getElementById("filter-products").addEventListener("change", applyfilters);


  // Get reference to the search button
const searchButton = document.getElementById("search-button");


function convertToLowerCase(str) {
  let result = '';
  for (let i = 0; i < str.length; i++) {
      const char = str.charAt(i);
      // Check if the character is an alphabet
      if (/[a-zA-Z]/.test(char)) {
          // Convert to lowercase
          result += char.toLowerCase();
      } else {
          // If not an alphabet, leave it unchanged
          result += char;
      }
  }
  return result;
}




// Add event listener to the search button
searchButton.addEventListener("click", function() {
    // Get the value from the search input field
    const searchText = document.getElementById("search-input").value;
    filteredList = productList.filter((product) => convertToLowerCase(product.username).includes(convertToLowerCase(searchText)));
    // convertToLowerCase(product.username)==convertToLowerCase(searchText)
    
    // console.log(searchText);
    // console.log(filteredList.length);
    if(filteredList.length==0){
      // console.log("hhhh");
      filteredList = productList.filter((product) => convertToLowerCase(product.device_name).includes(convertToLowerCase(searchText)));

    }
    
    if(filteredList.length==0){
      alert("Invalid User/Device name: " + searchText);
    }
    else{
      resetFilters();
      displayProducts(filteredList);
      templist= filteredList;
    }
    
    // Or you can call a function to perform further actions based on the search text
});



// remove filters
// Add event listener to the button
const removeFiltersButton = document.getElementById("remove-filters-button");
removeFiltersButton.addEventListener("click", function() {
    // Reset all filters
    resetFilters();
    displayProducts(productList);
    templist= productList;
    const searchInput = document.getElementById("search-input");
    searchInput.value = "";
});

// Function to reset all filters
function resetFilters() {
    // Reset date filters
    document.getElementById("start-date").value = "";
    document.getElementById("end-date").value = "";

    // Reset product filters
    document.querySelectorAll("#filter-products input[type='checkbox']").forEach(checkbox => {
        checkbox.checked = false;
    });

    // Reset status filters
    document.querySelectorAll("#filter-status a").forEach(link => {
        link.classList.remove("active");
    });
    

// Clear the data stored in the search box

    // filteredList = productList;
    

    // Apply your other filter reset logic here if any
    // For example, resetting price filters

    // After resetting all filters, you may want to reapply the filters or update the table
    // Call the function to display products after resetting filters
    // displayProducts(productList);
}


// });












