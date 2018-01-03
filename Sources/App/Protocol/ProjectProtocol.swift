//
//  ProjectProtocol.swift
//  ORCH-BrainPackageDescription
//
//  Created by Johnny Wang on 2017/12/28.
//

protocol ProjectProtocol {
/**
@api {get} /projects 取得所有專案清單
@apiName GetProjects
@apiGroup Project
@apiVersion 0.1.0
     
@apiUse SuccessResponseParam
@apiSuccessExample 成功回應
[
     {
     "id": 1,
     "name": "微笑不微笑",
     "abbreviation": "NotFunny"
     }
]
*/
    func index(_ req: Request) throws -> ResponseRepresentable
    
/**
@api {post} /projects 新增專案
@apiName CreateProject
@apiGroup Project
@apiVersion 0.1.0
@apiParam {String} name 專案全名
@apiParam {String} abbreviation 專案英文縮寫
@apiExample {post} 示範:
{
     "name": "微笑不微笑",
     "abbreviation": "NotFunny"
}
     
@apiUse SuccessResponseParam
@apiUse SuccessExample
*/
    func store(_ req: Request) throws -> ResponseRepresentable
    
/**
@api {get} /projects/:id 取得單一專案清單
@apiName GetProject
@apiGroup Project
@apiVersion 0.1.0
@apiParam {Int} id 專案ID.
@apiUse SuccessResponseParam
@apiUse SuccessExample
@apiuse ErrorResponseParam
@apiErrorExample 失敗回應:
{
     "identifier": "Vapor.Abort.notFound",
     "reason": "No Project with that identifier was found.",
     "debugReason": "No Project with that identifier was found.",
     "error": true
}
*/
    func show(_ req: Request, project: Project) throws -> ResponseRepresentable
    func delete(_ req: Request, project: Project) throws -> ResponseRepresentable
    func clear(_ req: Request) throws -> ResponseRepresentable
    func update(_ req: Request, project: Project) throws -> ResponseRepresentable
}

/**
 @apiDefine SuccessResponseParam
 @apiSuccess {Int} id 專案編號
 @apiSuccess {String} name 專案全名
 @apiSuccess {String} abbreviation 專案英文縮寫
 */

/**
 @apiDefine ErrorResponseParam
 @apiError identifier 錯誤識別標籤
 @apiError reason 原因
 @apiError debugReason 原因(Debug Mode)
 @apiError error 錯誤布林值
 */

/**
 @apiDefine SuccessExample
 @apiSuccessExample 成功回應
 {
 "id": 1,
 "name": "微笑不微笑",
 "abbreviation": "NotFunny"
 }
 */
