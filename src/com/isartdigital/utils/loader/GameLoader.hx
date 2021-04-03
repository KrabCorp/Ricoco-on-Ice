package com.isartdigital.utils.loader;
import animateAtlasPlayer.assets.AssetManager;
import animateAtlasPlayer.core.Animation;
import com.isartdigital.utils.events.AssetsLoaderEvent;
import lime.app.Future;
import lime.utils.AssetLibrary;
import openfl.display.BitmapData;
import openfl.display.MovieClip;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.media.Sound;
import openfl.text.Font;
import openfl.utils.Assets;
import openfl.utils.ByteArray;

/**
 * Classe gérant le chargement et la mise en cache des assets
 * @author Chadi Husser
 */
class GameLoader extends Sprite
{
	/**
	 * cache des textes chargé
	 */
	private static var textCache:Map<String, String> = new Map<String, String>();
	
	/**
	 * liste des fichiers à charger
	 */
	private var files:Array<AssetData>;

	
	/**
	 * asset manager pour charger des atlas
	**/
	private static var assetManager:AssetManager = new AssetManager();
	
	/**
	 * objet de chargement en cours
	 */
	private  var current:AssetData;

	/**
	 * indice de chargement courant
	 */
	private  var loadingInd : Int;

	/**
	 * nombre de fichier à charger (initialisé à chaque chargement)
	 */
	private var nFile : Int;
	
	/**
	 * nombre de byte chargé pour le loading actuel
	 */
	private var currentByteLoaded : Int = 0;
	
	/**
	 * nombre de byte total à charger pour le loading actuel
	 */
	private var currentByteTotal :Int = 0;
	
	/**
	 * Retourne une Animation chargé avec son pId
	 * @param	pId
	 * @return
	 */
	public static function getAnimationFromAtlas(pId:String) : Animation {
		return assetManager.createAnimation(pId);
	}
	/**
	 * Retourne un BitmapData chargé avec son pId
	 * @param	pId
	 * @return
	 */
	public static function getBitmapData(pId:String) : BitmapData {
		return Assets.getBitmapData(pId);
	}
	
	/**
	 * Retourne un ByteArray chargé avec son pId
	 * @param	pId
	 * @return
	 */
	public static function getBytes(pId:String) : ByteArray {
		return Assets.getBytes(pId);
	}
	
	/**
	 * Retourne une Font chargé avec son pId
	 * @param	pId
	 * @return
	 */
	public static function getFont(pId:String) : Font {
		return Assets.getFont(pId);
	}
	
	/**
	 * Retourne une Library chargé avec son pId
	 * @param	pId
	 * @return
	 */
	public static function getLibrary(pId:String) : AssetLibrary {
		return Assets.getLibrary(pId);
		
	}
	
	/**
	 * Retourne un MovieClip chargé avec son pId
	 * @param	pId
	 * @return
	 */
	public static function getMovieClip(pId:String) : MovieClip {
		return Assets.getMovieClip(pId);
	}
	
	/**
	 * Retourne une Music chargé avec son pId
	 * @param	pId
	 * @return
	 */
	public static function getMusic(pId:String) : Sound {
		return Assets.getMusic(pId);
	}
	
	/**
	 * Retourne un Sound chargé avec son pId
	 * @param	pId
	 * @return
	 */
	public static function getSound(pId:String) : Sound {
		return Assets.getSound(pId);
	}
	
	/**
	 * Retourne un String chargé avec son pId
	 * @param	pId
	 * @return
	 */
	public static function getText(pId:String) : String {
		return textCache.get(pId);
	}

	public function new() {
		super();
		files = new Array<AssetData>();
	}
	
	public function addAtlas(pId:String) : Void {
		addAssetData(pId, AssetType.Atlas);
	}
	
	public function addBitmapData(pId:String) : Void {
		addAssetData(pId, AssetType.BitmapData);
	}
		
	public function addBytes(pId:String) : Void {
		addAssetData(pId, AssetType.Bytes);
	}
	
	public function addFont(pId:String) : Void {
		addAssetData(pId, AssetType.Font);
	}
	
	public function addLibrary(pId:String) : Void {
		addAssetData(pId, AssetType.Library);
	}
	
	public function addMovieClip(pId:String) : Void {
		addAssetData(pId, AssetType.MovieClip);
	}
	
	public function addMusic(pId:String) : Void {
		addAssetData(pId, AssetType.Music);
	}
	
	public function addSound(pId:String) : Void {
		addAssetData(pId, AssetType.Sound);
	}
	
	public function addText(pId:String) : Void {
		addAssetData(pId, AssetType.Text);
	}

	public function load() : Void {
		addEventListener(Event.ENTER_FRAME, loadProgress);
		loadingInd = -1;
		nFile = files.length;
		loadNext();
	}

	private function addAssetData(pId:String, pType:AssetType) : Void {
		trace("add " + pType + " : " + pId);
		files.push( { id: pId, type: pType});
	}
	
	private function loadProgress(pEvent:Event) : Void {
		var lFilesLoaded:Float =  loadingInd;
		if (currentByteTotal != 0) lFilesLoaded += (currentByteLoaded / currentByteTotal);
		
		dispatchEvent(new AssetsLoaderEvent(AssetsLoaderEvent.PROGRESS, current.id, current, lFilesLoaded, nFile));
	}
	
	private function loadNext() : Void {
		while (files.length > 0)
		{
			current = files.shift();
			loadingInd++;
			loadFromAssetData(current);
			return;
		}
		trace ("loadNext");

		removeEventListener(Event.ENTER_FRAME,loadProgress);
		dispatchEvent(new AssetsLoaderEvent(AssetsLoaderEvent.COMPLETE));
	}
	
	private function loadFromAssetData(pData:AssetData) {
		if (pData.type == AssetType.Atlas) {
			assetManager.enqueue(pData.id);
			assetManager.loadQueue(currentComplete);
		} else {
			var lFuture:Future<Dynamic> = null;
			switch pData.type {
				case AssetType.BitmapData:
					lFuture = Assets.loadBitmapData(pData.id);
				case AssetType.Bytes:
					lFuture = Assets.loadBytes(pData.id);
				case AssetType.Font:
					lFuture = Assets.loadFont(pData.id);
				case AssetType.Library:
					lFuture = Assets.loadLibrary(pData.id);
				case AssetType.MovieClip:
					lFuture = Assets.loadMovieClip(pData.id);
				case AssetType.Music:
					lFuture = Assets.loadMusic(pData.id);
				case AssetType.Sound:
					lFuture = Assets.loadSound(pData.id);
				case AssetType.Text:
					lFuture = Assets.loadText(pData.id);
				default:
			}
			lFuture.onComplete(currentComplete);
			lFuture.onProgress(currentProgress);
			lFuture.onError(currentError);
		}
		
	}
	
	
	private function currentComplete(pData:Dynamic) : Void {
		dispatchEvent(new AssetsLoaderEvent(AssetsLoaderEvent.CURRENT_COMPLETE, current.id));
		
		// la classe Assets de OpenFL ne garde pas en cache les string, nous sommes donc obligé de mettre en cache manuellement nos textes
		if (current.type == AssetType.Text) {
			textCache.set(current.id, pData);
		}
		
		current = null;
		currentByteLoaded = currentByteTotal = 0;
		loadNext();
	}
	
	private function currentProgress(pLoaded:Int, pTotal:Int) : Void {
		currentByteLoaded = pLoaded;
		currentByteTotal = pTotal;
	}
	
	private function currentError(pData:Dynamic) : Void {
		trace(pData);
		throw pData;
	}

}