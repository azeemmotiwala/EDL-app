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
//   {'log_id':'1279172','device_name': 'AFG', 'roll_no':'210070018','issue_date': "2024-03-15", 'return_date':"2024-03-20", 'location':'Jaipur'},
  ]


// log_id , device_name , roll_no  , issue_date , return_date , location
let filteredList = productList;
let templist= productList;
function fetchData(){

  fetch('http://192.168.43.144:8000/logs/')
  .then(response =>{
    response.json().then((r)=>{console.log(r);
    let re = r['logs'];
    productList = [];
    // console.log(re);
     re.forEach((res)=>{
      // console.log(res[8]==null);
     

      productList.push({'log_id':res[0],'roll_no':res[1],'tag_id':res[2],'device_name':res[3],'location':res[4],'issue_date':res[5],'return_deadline':res[6],'return_date':res[7],'extended_deadline':res[8]});
    });
        filteredList = productList;
    displayProducts(productList);
    templist= productList;
    filteredList = productList;
    count_logs();
    createProductCheckboxes(productList);

  });    
  }).catch((err)=>{
    alert("Server Error");
  })

     
// res = ["1"	,
// " 210070093",
//  "348108",	"AFG",	"Hostel-9",	"2024-04-05",	"2024-04-05","",""]
//      productList.push({'log_id':res[0],'roll_no':res[1],'tag_id':res[2],'device_name':res[3],'location':res[4],'issue_date':res[5],'return_deadline':res[6],'return_date':res[7],'extended_deadline':res[8]});
//  //   });


  // displayProducts(productList);


}

function reload(){
  resetFilters();
  fetchData();

}

function closeDialog() {
  const dialog = document.getElementById('myDialog');
  console.log(dialog);
  dialog.close();
}

// Function to perform the action (e.g., API call) after confirmation
function confirmAction() {
  console.log("came");
  

  // Implement your action here
  // For example, make an API call
 
  // Close the dialog after action
  closeDialog();
}

function countLogs() {
  return filteredList.length;
}


// Generate the HTML content
function count_logs(){
  
      var totalLogsElement = document.getElementById("totalLogs");
      var totalLogs = countLogs();
      totalLogsElement.textContent = totalLogs;
}


const productTable = document.getElementById("product-table");



function showDialogNearButton(button, rollNo) {
  const dialog = document.getElementById('myDialog');
  
  // Fetch data based on roll number using an API call
  let data ;
  fetch(`http://192.168.43.144:8000/users/${rollNo}`)
  .then(response =>{
    response.json().then((re)=>{console.log(re);
  // re = ["fasf","fas","greg","grgr","ar","gregg","rgafr","Agr","gar"];
    // let re = r['logs'];
    data = {"Roll No":re[1],"Name":re[2],"Email":re[3],"Department":re[4]+" "+re[5],"Year":re[6],"Phone no":re[7]};
    
 
  
      // Update dialog content with fetched data
      updateDialogData(data);
      
      // Calculate position of the button
      const buttonRect = button.getBoundingClientRect();
      const dialogWidth = dialog.offsetWidth;
      const dialogHeight = dialog.offsetHeight;
      
      // Set position of the dialog box near the button
      dialog.style.position = 'fixed';
      dialog.style.top = `${buttonRect.top + buttonRect.height}px`;
      dialog.style.left = `${buttonRect.left - dialogWidth}px`;
      
      dialog.showModal();


      window.addEventListener('scroll', function () {
        const newButtonRect = button.getBoundingClientRect();
        dialog.style.top = `${newButtonRect.top + newButtonRect.height}px`;
        dialog.style.left = `${newButtonRect.left - dialogWidth}px`;
      });

    });
  });
}

function updateDialogData(userData) {
  const userDataTableBody = document.querySelector('#userDataTable tbody');
  userDataTableBody.innerHTML = ''; // Clear existing rows
  
  // Loop through the keys of the userData object
  Object.keys(userData).forEach(key => {
    const row = document.createElement('tr');
    row.innerHTML = `
      <td>${key}</td>
      <td>${userData[key]}</td>
    `;
    userDataTableBody.appendChild(row);
  });
}

function fetchuserinfo(rollNo) {
  console.log(rollNo);


}
    
     
  // Replace this with your actual API call
  // Example: return fetch(`your_api_url/${rollNo}`).then(response => response.json());




// Function to close the dialog



// Function to dynamically create table rows
function displayProducts(filteredList) {
  productTable.innerHTML = ""; // Clear previous content
  productTable.innerHTML = ''; // Clear existing rows

  filteredList.sort((a, b) => {

    if ('log_id' in a && 'log_id' in b) {
      return a.log_id - b.log_id;
    } else if ('log_id' in a) {
      return -1; // Place objects with log_id first
    } else if ('log_id' in b) {
      return 1; // Place objects with log_id first
    } else {
      return 0; // Leave order unchanged if neither object has log_id
    }
  });
  
  
  (filteredList || productList).forEach(product => {
    console.log(product.rollNo);
    const row = document.createElement('tr');
    row.innerHTML = `
      <td>${product.log_id}</td>
      <td><button onclick="showDialogNearButton(this,'${product.roll_no}')">${product.roll_no}</button></td> <!-- Fix: Added missing single quotes around ${product.roll_no} -->      <td>${product.tag_id}</td>
      <td>${product.device_name}</td>
      <td>${product.location}</td>
      <td>${product.issue_date}</td>
      <td>${product.return_deadline}</td>
      <td>${product.return_date}</td>
      <td>${product.extended_deadline}</td>
    `;
    productTable.appendChild(row);
  });
}



  // function displayProducts(filteredList) {
  //   productTable.innerHTML = ""; // Clear previous content

  //   (filteredList || productList).forEach((product) => {
  //     const tableRow = document.createElement("tr");

  //     // Create and append name cell
  //     const log_id = document.createElement("td");
  //     log_id.textContent = product.log_id;
  //     tableRow.appendChild(log_id);

  //     const device_name = document.createElement("td");
  

  //     const roll_no = document.createElement("td");
  //     roll_no.textContent = product.roll_no;
  //     tableRow.appendChild(roll_no);

  //     const tag_id = document.createElement("td");
  //     tag_id.textContent = product.tag_id;
  //     tableRow.appendChild(tag_id);
  //   device_name.textContent = product.device_name;
  //     tableRow.appendChild(device_name);
  //     const location = document.createElement("td");
  //     location.textContent = product.location;
  //     tableRow.appendChild(location);

  //     const issue_date = document.createElement("td");
  //     issue_date.textContent = product.issue_date;
  //     tableRow.appendChild(issue_date);

  //           const return_deadline = document.createElement("td");
  //     return_deadline.textContent = product.return_deadline;
  //     tableRow.appendChild(return_deadline);

  //     const return_date = document.createElement("td");
  //     return_date.textContent = product.return_date;
  //     tableRow.appendChild(return_date);


  //     const extended_deadline = document.createElement("td");
  //     extended_deadline.textContent = product.extended_deadline;
  //     tableRow.appendChild(extended_deadline);


  //     // Append the row to the table
  //     productTable.appendChild(tableRow);
  //   });
  // }


// Set to store added product names
const addedProductNames = new Set();

// Function to create checkboxes for products

function createProductCheckboxes(products) {
  addedProductNames.clear(); // Clear the set of added product names
  
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
      // displayProducts(filteredList);
   }


   if(filtervalue!='all'){
    if (filtervalue === "returned") {
      filteredList = filteredList.filter((product) => product.return_date!=null);
    } else if (filtervalue === "not returned") {
      filteredList = filteredList.filter((product) => product.return_date==null);
    } 
    // else {
    //   filteredList = filteredList.filter((product) => product.category === filterValue);
    // }

}
   var totalLogsElement = document.getElementById("totalLogs");
var totalLogs = filteredList.length;
totalLogsElement.textContent = totalLogs;


   displayProducts(filteredList);



}






// Populate the product checkboxes and display all products initially

fetchData();

  // Initial display of products
  // bydefault();







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

  // applyfilters();
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
    filteredList = productList.filter((product) => convertToLowerCase(product.roll_no).includes(convertToLowerCase(searchText)));
    // convertToLowerCase(product.roll_no)==convertToLowerCase(searchText)
    
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
      count_logs();
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












