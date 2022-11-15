const functions = require("firebase-functions");

const admin = require("firebase-admin");
const firebase = require("firebase/app");
require("firebase/auth");
require("firebase/firestore");

const serviceAccount = require("../../../serviceAccountKey.json");

const firebaseApp = admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://data-visualization-proje-d998b-default-rtdb.firebaseio.com",
});

const express = require("express");
const cors = require("cors");

const app = express();
app.use(cors({origin: true}));

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
                db.collection("projects").doc(docRef.id).update({
                    projectId: docRef.id,
                });
                return docRef.id;
            });

            return res.status(200).send({status: "Success", msg: "Project saved"});
        } catch (error) {
            console.log(error);
            return res.status(500).send({status: "Failed", msg: error});
        }
    })();
});

// get project information
app.get("/api/leader/:id/:projectId", (req, res) => {
    (async ()=>{
        try{
            const repDoc = await db.collection("projects").doc(req.params.projectId);
            const projectDetail = await repDoc.get();
            const response = projectDetail.data();
            return res.status(200).send({status: "Success", data: response});
        } catch (error) {
            console.log(error);
            return res.status(500).send({status: "Failed", msg: error});
        }
    })();
});

//get list of 
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
