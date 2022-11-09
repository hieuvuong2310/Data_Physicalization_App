const functions = require("firebase-functions");
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const admin = require("firebase-admin");
const firebase = require("firebase/app");
require("firebase/auth");
require("firebase/firestore");

const serviceAccount = require("../../../serviceAccountKey.json");

const firebaseApp = admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://data-visualization-proje-d998b-default-rtdb.firebaseio.com",
});

// const auth = require("firebase/auth");
// const authenticate = auth.getAuth();
const express = require("express");
const cors = require("cors");
const router = express.Router();
const {signUp, signIn} = require("./src/login");
// import {firebase} from "firebase/app";
// import "firebase/auth";
// const { getAuth} = require("firebase-admin/auth");
// import { getAuth, signInWithEmailAndPassword } from "firebase-admin/auth";
// const auth = getAuth();
// main app
const app = express();
app.use(cors({origin: true}));
// app.use(signIn);
// app.use(signUp);

// Main database
const db = admin.firestore();

//Main authentication
// const auth = admin.firebase.auth();
var userId = "";
// Routes
app.get("/", (req, res) =>{
    return res.status(200).send("Successfully launch the app");
});
// Create -> post()
app.post("/api/create", (req, res) => {
    (async ()=>{
        try {
            await db.collection("test").doc("123").create({
                id: "123",
                name: req.body.name,
            });
            return res.status(200).send({
                status: "Success",
                msg: "Data Saved",
            });
        } catch (error) {
            console.log(error);
            return res.status(500).send({status: "Failed", msg: error});
        }
    })();
});

//Sign up account
// app.post("/api/signup", async (req, res) =>{
//     // const user = {
//     //     email: req.body.email,
//     //     passsword: req.body.password,
//     //     name: req.body.name,
//     //     role: req.body.role,
//     //     returnSecureToken: true,
//     // }
//     // app.post("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDG_uR2ZErB8G4LXXKpBnB9n3mIyRFaXzA",
//     //     {
//     //         headers: {
//     //             Authorization: `Bearer ${AIzaSyDG_uR2ZErB8G4LXXKpBnB9n3mIyRFaXzA}`,
//     //             'content-type': 'application/octet-stream',
//     //         },
//     //         // body: {
//     //         //     email: user.email,
//     //         //     passsword: user.password,
//     //         //     returnSecureToken: true,
//     //         // }
//     //     }
//     // );
//     try{
//         console.log(req.body);
//         const user = {
//             email: req.body.email,
//             passsword: req.body.password,
//             name: req.body.name,
//             role: req.body.role,
//         }
//         const userResponse = await admin.auth().createUserWithEmailAndPassword({
//             email: user.email,
//             password: user.password,
//             emailVerified: true,
//             disabled: false,
//         });
//         res.json(userResponse);
//         let userId = userResponse.uid;
//         await db.collection("users").doc(userResponse.uid).create({
//             id: userResponse.uid,
//             email: user.email,
//             name: user.name,
//             role: user.role,
//         });
//         return res.status(200).send({
//             status: "Success",
//             msg: "Data Saved",
//         });

//     } catch(error) {
//         console.log(error);
//         return res.status(500).send({status: "Failed", msg: error});
//     } 
// });

// app.post("/api/signup", signUp);

//post for login
// app.post("/api/login", async (req, res) => {
//     console.log(req.body);
//     const user = {
//         email: req.body.email,
//         passsword: req.body.password,
//     }
//         try{
//             // const userCredential = await signInWithEmailAndPassword(auth, user.email, user.password);
//                 // .then((userCredential) => {
//                 //     // Signed in 
//                 //     // const userEmail =  req.body.email;
//                 //     // const userPassword = req.body.passsword;
//                 //     const userData = userCredential.user;
//                 //     // ...
//                 // })
//                 console.log("a");
//             // const userResponse = await admin.auth().getUserByEmail(user.email);
//             const userResponse = await admin.auth().signIn(user.email, user.password);
//             const userId = userResponse.uid;
//             const data = db.collection("users").doc(userId).get();
//             const userData = {
//                 email: data.email,
//                 role: data.role,
//                 name: data.name,
//                 id: data.id,
//             }
//             // res.json(data);
//             console.log(userData.email);
//             return res.status(200).send({
//                 status: "Success",
//                 msg: "Data Saved",
//             });
//         } catch(error){
//             console.log(error);
//             return res.status(500).send({status: "Failed", msg: error});
//         }
    

// });
//post -> project info
app.post("/api/leader/:id/projectInfo", (req, res) => {
    (async ()=>{
        const projectData = {
            projectName: req.body.projectName,
            projectPeople: req.body.projectPeople,
            projectActivities: req.body.projectActivities,
        }
        try{
            await db.collection("projects").add({
                        projectName: projectData.projectName,
                        projectPeople: projectData.projectPeople,
                        projectActivities: projectData.projectActivities,
                        leader: req.params.id,
            })
            .then(function(docRef) {
                console.log("Document written with ID: ", docRef.id);
            });
            return res.status(200).send({status: "Success", msg: "Project saved"});
        } catch (error) {
            console.log(error);
            return res.status(500).send({status: "Failed", msg: error});
        }
    })();
});
// get -> get()
app.get("/api/get/:id", (req, res) => {
    (async ()=>{
        try {
            const repDoc = db.collection("test").doc(req.params.id);
            const userDetail = await repDoc.get();
            const response = userDetail.data();
            return res.status(200).send({status: "Success", data: response});
        } catch (error) {
            console.log(error);
            return res.status(500).send({status: "Failed", msg: error});
        }
    })();
});

// Get all
app.get("/api/getAll", (req, res) => {
    (async ()=>{
        try {
            const query = db.collection("test");
            const response = [];
            await query.get().then((data) =>{
                const docs = data.docs;
                docs.map((doc)=>{
                    const selectedItem = {
                        name: doc.data().name,
                    };
                    response.push(selectedItem);
                });
                return response;
            });
            return res.status(200).send({status: "Success", data: response});
        } catch (error) {
            console.log(error);
            return res.status(500).send({status: "Failed", msg: error});
        }
    })();
});

// update -> put()
app.put("/api/update/:id", (req, res) => {
    (async ()=>{
        try {
            const repDoc = db.collection("test").doc(req.params.id);
            await repDoc.update({
                id: req.body.id,
                name: req.body.name,
            });
            return res.status(200).send({status: "Success", msg: "Data updated"});
        } catch (error) {
            console.log(error);
            return res.status(500).send({status: "Failed", msg: error});
        }
    })();
});
// Delete -> delete()
app.delete("/api/delete/:id", (req, res) => {
    (async ()=>{
        try {
            const repDoc = db.collection("test").doc(req.params.id);
            await repDoc.delete();
            return res.status(200).send({status: "Success", msg: "Data removed"});
        } catch (error) {
            console.log(error);
            return res.status(500).send({status: "Failed", msg: error});
        }
    })();
});
// export the api to firebase cloud function
exports.app = functions.https.onRequest(app);
