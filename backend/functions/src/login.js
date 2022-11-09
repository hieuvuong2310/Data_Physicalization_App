const admin = require("firebase-admin/app");
const firebase = require("firebase/app");
const {getAuth} = require("firebase-admin/auth");
const auth = getAuth();
require("firebase/firestore");

// module.exports = validateFirebaseIdToken = async (req, res, next) => {
//     console.log('Check if request is authorized with Firebase ID token');
  
//     if ((!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) &&
//         !(req.cookies && req.cookies.__session)) {
//       console.error('No Firebase ID token was passed as a Bearer token in the Authorization header.',
//           'Make sure you authorize your request by providing the following HTTP header:',
//           'Authorization: Bearer <Firebase ID Token>',
//           'or by passing a "__session" cookie.');
//       res.status(403).send('Unauthorized');
//       return;
//     }
  
//     let idToken;
//     if (req.headers.authorization && req.headers.authorization.startsWith('Bearer ')) {
//       console.log('Found "Authorization" header');
//       // Read the ID Token from the Authorization header.
//       idToken = req.headers.authorization.split('Bearer ')[1];
//     } else if(req.cookies) {
//       console.log('Found "__session" cookie');
//       // Read the ID Token from cookie.
//       idToken = req.cookies.__session;
//     } else {
//       // No cookie
//       res.status(403).send('Unauthorized');
//       return;
//     }
  
//     try {
//       const decodedIdToken = await admin.auth().verifyIdToken(idToken);
//       console.log('ID Token correctly decoded', decodedIdToken);
//       req.user = decodedIdToken;
//       next();
//       return;
//     } catch (error) {
//       console.error('Error while verifying Firebase ID token:', error);
//       res.status(403).send('Unauthorized');
//       return;
//     }
//   };

//Sign up helper function
exports.signUp = (req, res) => {
    const user = {
        email: req.body.email,
        passsword: req.body.password,
        name: req.body.name,
        role: req.body.role,
    }
    console.log(user);
    if(!user.email || !user.passsword){
        return res.status(422).json({
            email: "email is required",
            password: "password is require",
        });
    }
    createUserWithEmailAndPassword( auth, user.email, user.password)
        .then((userData) =>{
            return res.status(201).json(userData);
        })
        .catch(function (error) {
            let errorCode = error.code;
            let errorMessage = error.message;
            if(errorCode == "auth/weak-password"){
                return res.status(500).json({ error : errorMessage});
            }
            else{
                return res.status(500).json({error: errorMessage});
            }
        });
};

exports.signIn = (req, res) => {
    const user = {
        email: req.body.email,
        passsword: req.body.password,
    }
    // if(!user.email || !user.passsword){
    //     return res.status(422).json({
    //         email: "email is required",
    //         password: "password is require",
    //     });
    // }

    // firebase
    //     .auth()
    //     .signInWithEmailAndPassword(user.email, user.passsword)
    //     .then((userData) => {
    //         return res.status(200).json(userData);
    //     })
    //     .catch(function (error) {
    //         let errorCode = error.code;
    //         let errorMessage = error.message;
    //         if(errorCode == "auth/wrong-password"){
    //             return res.status(500).json({ error : errorMessage});
    //         }
    //         else{
    //             return res.status(500).json({error: errorMessage});
    //         }
    //     });
};
  