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



productList = [ 
//  {'device_id':'1279172','device_name': 'AFG', 'username':'210070018','issue_date': "2024-03-15", 'return_date':"2024-03-20", 'location':'Jaipur'},
//  {'device_id':'123456','device_name': 'AFG', 'username':'210070018', 'issue_date':"2024-03-17",'return_date':"2024-04-05", 'location':'Hostel-6'},
// {'device_id':'56984215436656563','device_name': 'DSO', 'username':'210070092', 'name': 'Chanakya', 'phone_no':8687524512,'issue_date':"2024-03-17",'return_date':"2024-04-05", 'location':'Hostel-6'}
// ,  {'device_id':'69556215460656725','device_name': 'Pi-pico', 'username':'21d070051', 'name': 'Pratham', 'phone_no':7854265226,'issue_date':"2024-03-15",'return_date':"2024-04-10", 'location':'WEL-3'}
// ,
//   {'device_id':'36156215720656132','device_name': 'AFG', 'username':'210070018', 'name': 'Azeem', 'phone_no':8456561235,'issue_date':"2024-03-12",'return_date':"2024-04-11", 'location':'Hostel-15'}
//   ,  {'device_id':'37456214660656458','device_name': 'STM', 'username':'', 'name': '', 'phone_no':"",'issue_date':"",'return_date':"", 'location':''}

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

  fetch('http://192.168.43.144:8000/devices/')
  .then(response =>{
    response.json().then((r)=>{console.log(r);

    productList = [];
    console.log(r['devices']);
     r['devices'].forEach((res)=>{

      
      productList.push({'device_id': res[0],'device_name':res[4], 'serial_no':res[1], 'original_location':res[2], 'tag_id':res[3],'status':res[5],"verify":res[6],'latest_verify_date':res[7],"device_discription":res[8]});
    });





        filteredList = productList;
    displayProducts(productList);
    templist= productList;
    filteredList = productList;
    count_logs();
    createProductCheckboxes(productList);

 
    


  });    
  })
  .catch((r)=>{
    alert("Server Error");
  })

  displayProducts(productList);
  
  

}


function countDevices() {
  return filteredList.length;
}

// Function to count total issued devices
function countIssuedDevices() {
  return filteredList.filter(device => device.status=="Available").length;
}

// Generate the HTML content
function count_logs(){
  
    var totalDevicesElement = document.getElementById("totalDevices");
    var totalIssuedElement = document.getElementById("totalAvailable");
    var totalNotissuedElement = document.getElementById("totalNotavailable");

    var totalDevices = countDevices();
    var totalIssued = countIssuedDevices();
    var totalNotissued =  totalDevices - totalIssued;

    totalDevicesElement.textContent = totalDevices;
    totalIssuedElement.textContent = totalIssued;
    totalNotissuedElement.textContent = totalNotissued
}




  const productTable = document.getElementById("product-table");



  function displayProducts(filteredList) {
    productTable.innerHTML = ""; // Clear previous content
    // console.log(productList);
    // filteredList.sort((a, b) => a.device_id - b.device_id);
    filteredList.sort((a, b) => {

    if ('device_id' in a && 'device_id' in b) {
      return a.device_id - b.device_id;
    } else if ('device_id' in a) {
      return -1; // Place objects with device_id first
    } else if ('device_id' in b) {
      return 1; // Place objects with device_id first
    } else {
      return 0; // Leave order unchanged if neither object has device_id
    }
  });
    console.log(filteredList);
    filteredList.forEach((product) => {
      const tableRow = document.createElement("tr");

      // Create and append name cell
      const device_id = document.createElement("td");
      device_id.textContent = product.device_id;
      tableRow.appendChild(device_id);

      const serial_no = document.createElement("td");
      serial_no.textContent = product.serial_no;
      tableRow.appendChild(serial_no);

      const device_name = document.createElement("td");
      device_name.textContent = product.device_name;
      tableRow.appendChild(device_name);



      const original_location = document.createElement("td");
      original_location.textContent = product.original_location;
      tableRow.appendChild(original_location);

      const tag_id = document.createElement("td");
      tag_id.textContent = product.tag_id;
      tableRow.appendChild(tag_id);

      const status = document.createElement("td");
      status.textContent = product.status;
      tableRow.appendChild(status);

      // const verify = document.createElement("td");
      // verify.textContent = product.verify;
      // tableRow.appendChild(verify);

      const latest_verify_date = document.createElement("td");
      latest_verify_date.textContent = product.latest_verify_date;
      tableRow.appendChild(latest_verify_date);

      const device_discription = document.createElement("td");
      device_discription.textContent = product.device_discription;
      tableRow.appendChild(device_discription);


      // Append the row to the table
      productTable.appendChild(tableRow);
      console.log("came");
    });
  }


// Set to store added product names
const addedProductNames = new Set();

// Function to create checkboxes for products
function createProductCheckboxes(products) {
  addedProductNames.clear(); 
  const filterProductsList = document.getElementById("filter-products");

  filterProductsList.innerHTML = "";

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
    //  filterProductsByCheckboxes();
    applyfilters();
   });


}

function reload(){
  resetFilters();
  fetchData();

}



function applyfilters(filtervalue){
  console.log("hi");

  
  const startDate = document.getElementById("start-date").value;

  const endDate = document.getElementById("end-date").value;
  console.log(endDate);

  filteredList = templist.filter((product) => 
  {
    if(startDate=="" && endDate ==""){
      return true;
    }
    else if(startDate==""){
      return product.latest_verify_date <= endDate;
    }
    else if(endDate==""){
      return product.latest_verify_date >= startDate;
    }
    else{
      return product.latest_verify_date >= startDate &&product.latest_verify_date <= endDate;
    }
  }

  );
   //checkboxes
   const checkboxes = document.querySelectorAll("#filter-products input[type='checkbox']:checked");
  //  console.log(checkboxes);
   if (checkboxes.length != 0) {
    // console.log("gggggggggg");

      const selectedProducts = Array.from(checkboxes).map(checkbox => checkbox.value);
      filteredList = filteredList.filter(product => selectedProducts.includes(product.device_name));
      // displayProducts(filteredList);
    
   }
  //  console.log(filteredList);


   if(filtervalue!='all'){
        if (filtervalue === "available") {
          filteredList = filteredList.filter((product) => product.status=="Available");
        } else if (filtervalue === "not available") {
          console.log("ininn");
          filteredList = filteredList.filter((product) => product.status=="Not Available");
        } 
        // else {
        //   filteredList = filteredList.filter((product) => product.category === filterValue);
        // }

   }

   count_logs();

   displayProducts(filteredList);



}






// Populate the product checkboxes and display all products initially
fetchData();
  // Initial display of products
  // bydefault();





let filterValue = "all";

  // Filter functionality of clicking components
  document.querySelectorAll("#filter-status a").forEach((filter) => {
    filter.addEventListener("click", function (event) {
      event.preventDefault();
      filterValue = this.getAttribute("data-filter");
      document.querySelectorAll("#filter-status a").forEach(link => {
        link.classList.remove("active");
    });
    // Add 'active' class to the clicked link
    this.classList.add("active");
      
      applyfilters(filterValue);
    });
  });


  document.getElementById("date-filter-button").addEventListener("click", function () {
    let startDate = document.getElementById("start-date").value;

    let endDate = document.getElementById("end-date").value;
    if(startDate>endDate){
      alert("End Date can't be less than Start Date");
    }
    else{
      applyfilters(filterValue);

    }


  });
  

  document.getElementById("filter-products").addEventListener("change", function(){applyfilters(filterValue);});
  // console.log("here");

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
    filteredList = productList.filter((product) => convertToLowerCase(product.device_name).includes(convertToLowerCase(searchText)));
    // convertToLowerCase(product.username)==convertToLowerCase(searchText)
    if(filteredList.length==0){
      filteredList = productList.filter((product) => convertToLowerCase(product.serial_no).includes(convertToLowerCase(searchText)));


    }
    // console.log(searchText);
    // console.log(filteredList.length);

    
    if(filteredList.length==0){
      alert("Invalid User/Device name: " + searchText);
    }
    else{
      resetFilters();
      displayProducts(filteredList);
      count_logs();
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
  filterValue = "all";
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












