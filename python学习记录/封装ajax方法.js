import axios from 'axios'

export function http(url,method,data){
	return Promise((resolve,reject) =>{
		axios({
			baseurl: url;
			method: method;
			data: data;
			timeout: 30000;
		})
		.then(reponse =>{
			resolve(reponse.data)
			console.log('ok,200')
		}
		.catch(error =>{
			reject(error)
			console.log('error')
		}
		
	}
		
	)
}